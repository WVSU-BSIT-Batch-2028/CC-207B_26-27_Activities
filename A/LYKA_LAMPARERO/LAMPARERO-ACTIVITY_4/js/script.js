// Mobile menu
const menuToggle = document.getElementById("menu-toggle");
const navLinks = document.getElementById("nav-links");

menuToggle.addEventListener("click", () => {
  navLinks.classList.toggle("open");
});

navLinks.querySelectorAll("a").forEach((link) => {
  link.addEventListener("click", () => navLinks.classList.remove("open"));
});

// Reveal on scroll
const revealItems = document.querySelectorAll(".reveal");
const revealObserver = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("visible");
        revealObserver.unobserve(entry.target);
      }
    });
  },
  { threshold: 0.1 }
);
revealItems.forEach((item) => revealObserver.observe(item));

// Highlight active nav link
const sectionIds = ["about", "work", "stack", "contact"];
const sections = sectionIds
  .map((id) => document.getElementById(id))
  .filter(Boolean);
const links = navLinks.querySelectorAll("a");

function updateActiveLink() {
  let current = "about";
  sections.forEach((section) => {
    if (window.scrollY >= section.offsetTop - 160) {
      current = section.id;
    }
  });
  links.forEach((link) => {
    link.classList.toggle("active", link.getAttribute("href") === "#" + current);
  });
}

window.addEventListener("scroll", updateActiveLink);
updateActiveLink();

// GitHub contribution graph
const ghUser = "eysikiel";
const ghDots = document.getElementById("gh-dots");
const ghStats = document.getElementById("gh-stats");

async function loadGithubGraph() {
  let total = null;
  let repos = null;

  try {
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 8000);

    const res = await fetch(
      "https://github-contributions-api.jogruber.de/v4/" + ghUser + "?y=last",
      { signal: controller.signal }
    );

    clearTimeout(timeout);

    if (!res.ok) {
      throw new Error("GitHub contribution API returned " + res.status);
    }

    const data = await res.json();
    const days = data.contributions;

    if (!days || !days.length) {
      throw new Error("No contribution data returned.");
    }

    const firstDay = new Date(days[0].date + "T00:00:00").getDay();

    for (let i = 0; i < firstDay; i++) {
      const blank = document.createElement("span");
      blank.className = "gh-dot empty";
      ghDots.appendChild(blank);
    }

    ghDots.style.setProperty("--cols", Math.ceil((firstDay + days.length) / 7));

    total = 0;

    days.forEach((day) => {
      total += day.count;

      const dot = document.createElement("span");
      dot.className = "gh-dot";
      dot.dataset.level = day.level;
      dot.title = day.count + " contributions on " + day.date;

      ghDots.appendChild(dot);
    });
  } catch (error) {
    console.error("GitHub contribution error:", error);
    ghDots.style.display = "none";
  }

  try {
    const res = await fetch("https://api.github.com/users/" + ghUser);

    if (!res.ok) {
      throw new Error("GitHub user API returned " + res.status);
    }

    const user = await res.json();
    repos = user.public_repos;
  } catch (error) {
    console.error("GitHub repository error:", error);
  }

  const parts = [];

  if (total !== null) {
    parts.push(total + " contributions in the last year");
  }

  if (repos !== null) {
    parts.push(repos + " public repos");
  }

  ghStats.textContent = parts.length
    ? parts.join(" | ")
    : "Could not load GitHub stats. Visit github.com/" + ghUser;
}

loadGithubGraph();