// ---------- Projects  ----------
const tabList = document.getElementById("project-tabs");
const panelBox = document.getElementById("project-panels");

function isProjectPlaceholder(value) {
    return typeof value !== "string" || !value.trim() || /^\[.*\]$/.test(value.trim());
}

function escapeProjectText(value) {
    return String(value).replace(/[&<>"']/g, function (character) {
        return {
            "&": "&amp;",
            "<": "&lt;",
            ">": "&gt;",
            '"': "&quot;",
            "'": "&#39;"
        }[character];
    });
}

if (tabList && panelBox) {
    PROJECTS.forEach(function (project, index) {
        const firstShot = project.shots[0];
        const projectMeta = [project.role, project.period]
            .filter(function (item) { return !isProjectPlaceholder(item); })
            .map(escapeProjectText)
            .join("<br>");
        const stack = (project.stack || [])
            .filter(function (item) {
                return !isProjectPlaceholder(item) && item.toLowerCase() !== "not specified";
            })
            .map(escapeProjectText);

        // Tab button
        const tab = document.createElement("button");
        tab.className = "tab";
        tab.type = "button";
        tab.textContent = project.name;
        tab.setAttribute("aria-controls", "panel-" + project.id);
        tab.setAttribute("aria-pressed", String(index === 0));
        if (index === 0) {
            tab.classList.add("active");
        }
        tabList.appendChild(tab);

        // The panel that shows one project
        const panel = document.createElement("article");
        panel.className = "project-panel";
        panel.id = "panel-" + project.id;
        if (index === 0) {
            panel.classList.add("active");
        }

        panel.innerHTML = `
        <div class="preview">
            <button class="preview-trigger" type="button" aria-label="View ${escapeProjectText(project.name)} screenshot full size">
                <img src="assets/${escapeProjectText(project.folder)}/${escapeProjectText(firstShot[0])}" alt="${escapeProjectText(project.name)}: ${escapeProjectText(firstShot[1])}" loading="lazy">
            </button>
            ${projectMeta ? `<p class="preview-meta">${projectMeta}</p>` : ""}
        </div>
        <aside class="project-info">
            <h3>${escapeProjectText(project.name)}</h3>
            <p>${escapeProjectText(project.summary)}</p>
            ${stack.length ? `<ul class="project-stack" aria-label="Technology stack">${stack.map(function (item) { return `<li>${item}</li>`; }).join("")}</ul>` : ""}
            <a class="view-btn" href="project.html?id=${encodeURIComponent(project.id)}">View project</a>
        </aside>
    `;
        panelBox.appendChild(panel);

        const previewTrigger = panel.querySelector(".preview-trigger");
        const previewLightbox = document.getElementById("preview-lightbox");
        const previewLightboxImage = document.getElementById("preview-lightbox-image");
        const previewLightboxCaption = document.getElementById("preview-lightbox-caption");
        const previewLightboxClose = document.getElementById("preview-lightbox-close");

        previewTrigger.addEventListener("click", function () {
            previewLightboxImage.src = `assets/${project.folder}/${firstShot[0]}`;
            previewLightboxImage.alt = `${project.name}: ${firstShot[1]}`;
            previewLightboxCaption.textContent = `${project.name} - ${firstShot[1]}`;
            previewLightbox.hidden = false;
            document.body.classList.add("lightbox-open");
            previewLightboxClose.focus();
        });

        // Clicking a tab shows its panel and hides the others
        tab.addEventListener("click", function () {
            document.querySelectorAll(".tab").forEach(function (t) {
                t.classList.remove("active");
                t.setAttribute("aria-pressed", "false");
            });
            document.querySelectorAll(".project-panel").forEach(function (p) {
                p.classList.remove("active");
            });
            tab.classList.add("active");
            tab.setAttribute("aria-pressed", "true");
            panel.classList.add("active");
        });
    });
}

const previewLightbox = document.getElementById("preview-lightbox");
if (previewLightbox) {
    const previewLightboxClose = document.getElementById("preview-lightbox-close");
    let previewReturnFocus = null;

    function closePreviewLightbox() {
        previewLightbox.hidden = true;
        document.body.classList.remove("lightbox-open");
        if (previewReturnFocus) {
            previewReturnFocus.focus();
        }
    }

    document.querySelectorAll(".preview-trigger").forEach(function (trigger) {
        trigger.addEventListener("click", function () {
            previewReturnFocus = trigger;
        });
    });

    previewLightboxClose.addEventListener("click", closePreviewLightbox);
    previewLightbox.addEventListener("click", function (event) {
        if (event.target === previewLightbox) {
            closePreviewLightbox();
        }
    });
    document.addEventListener("keydown", function (event) {
        if (!previewLightbox.hidden && event.key === "Escape") {
            closePreviewLightbox();
        }
    });
}

