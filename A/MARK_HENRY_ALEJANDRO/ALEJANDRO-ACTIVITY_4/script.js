const themeButton = document.querySelector('#theme');
const menuButton = document.querySelector('#menu');
const navigation = document.querySelector('#navigation');
const root = document.documentElement;

function applyTheme(theme) {
  root.dataset.theme = theme;
  const dark = theme === 'dark';
  themeButton.textContent = dark ? 'Light' : 'Dark';
  themeButton.setAttribute('aria-label', dark ? 'Switch to light mode' : 'Switch to dark mode');
}

let savedTheme;
try { savedTheme = localStorage.getItem('portfolio-theme'); } catch (_) {}
applyTheme(savedTheme === 'dark' ? 'dark' : 'light');

themeButton.addEventListener('click', () => {
  const theme = root.dataset.theme === 'dark' ? 'light' : 'dark';
  applyTheme(theme);
  try { localStorage.setItem('portfolio-theme', theme); } catch (_) {}
});

function closeMenu() {
  navigation.classList.remove('open');
  menuButton.setAttribute('aria-expanded', 'false');
}
menuButton.addEventListener('click', () => {
  const open = navigation.classList.toggle('open');
  menuButton.setAttribute('aria-expanded', String(open));
});
navigation.querySelectorAll('a').forEach(link => link.addEventListener('click', closeMenu));
document.addEventListener('keydown', event => {
  if (event.key === 'Escape') closeMenu();
});
document.querySelector('#year').textContent = new Date().getFullYear();

const terminalForm = document.querySelector('#terminal-form');
const commandInput = document.querySelector('#terminal-command');
const output = document.querySelector('#terminal-output');
const missionLabel = document.querySelector('#mission-label');
const missionMeter = document.querySelector('#mission-meter');
const destinations = ['about', 'skills', 'projects', 'contact'];
const explored = new Set();
const history = [];
let historyIndex = 0;
let navigationTimer;

function printLine(message, className = '') {
  const line = document.createElement('p');
  line.textContent = message;
  if (className) line.className = className;
  output.append(line);
  // Keep the most recent output visible without scrolling the entire page.
  output.scrollTop = output.scrollHeight;
}

function updateMission() {
  const count = explored.size;
  missionLabel.textContent = count === 4 ? 'MISSION COMPLETE 4 / 4' : `EXPLORED ${count} / 4`;
  missionMeter.textContent = `[${'#'.repeat(count)}${'-'.repeat(4 - count)}]`;
}

function openSection(name) {
  if (!destinations.includes(name) && name !== 'home') {
    printLine('Section not found. Type ls to see available sections.');
    return;
  }
  if (destinations.includes(name)) {
    const wasComplete = explored.size === 4;
    const alreadyVisited = explored.has(name);
    explored.add(name);
    updateMission();
    printLine(alreadyVisited ? `Reopening ${name}...` : `Discovered ${name}! (+1 point)`);
    if (!wasComplete && explored.size === 4) {
      printLine('MISSION COMPLETE! You explored the entire portfolio.', 'terminal-success');
    }
  } else {
    printLine('Returning home...');
  }
  clearTimeout(navigationTimer);
  navigationTimer = setTimeout(() => {
    const section = document.getElementById(name);
    section.setAttribute('tabindex', '-1');
    location.hash = name;
    section.focus({preventScroll: true});
    section.scrollIntoView({block: 'start'});
  }, 500);
}

function runCommand(raw) {
  const command = raw.trim().toLowerCase();
  if (!command) return;
  history.push(raw.trim());
  historyIndex = history.length;
  printLine(`guest@mac-mac:~$ ${raw.trim()}`, 'command-echo');
  const [verb, ...args] = command.split(/\s+/);
  const target = args.join(' ');
  switch (verb) {
    case 'help':
      printLine('ls           list portfolio sections\nopen <page>  explore a section\nwhoami       meet the developer\nstatus       show mission progress\nclear        clear terminal output\nreset        restart the challenge\nmail         show contact email');
      break;
    case 'ls':
      printLine(destinations.map(name => `${explored.has(name) ? '[x]' : '[ ]'} ${name}`).join('\n'));
      break;
    case 'open':
    case 'cd':
      openSection(target);
      break;
    case 'whoami':
      printLine('Mark Henry Alejandro\nBS Information Technology | WVSU\nSoftware development, design and research.');
      break;
    case 'status':
      printLine(`${explored.size}/4 sections explored.\n${destinations.filter(name => !explored.has(name)).join(', ') || 'All sections discovered!'}`);
      break;
    case 'mail':
      printLine('markhenryalejandro@gmail.com');
      break;
    case 'clear':
      output.replaceChildren();
      break;
    case 'reset':
      clearTimeout(navigationTimer);
      explored.clear();
      updateMission();
      output.replaceChildren();
      printLine('Mission restarted. Type ls to begin again.');
      break;
    default:
      if (destinations.includes(verb) && !target) openSection(verb);
      else printLine(`Unknown command: ${verb}. Type help for available commands.`);
  }
}

terminalForm.addEventListener('submit', event => {
  event.preventDefault();
  runCommand(commandInput.value);
  commandInput.value = '';
  commandInput.focus({preventScroll: true});
});

document.querySelectorAll('[data-command]').forEach(button => {
  button.addEventListener('click', () => {
    runCommand(button.dataset.command);
    commandInput.value = '';
    commandInput.focus({preventScroll: true});
  });
});

commandInput.addEventListener('keydown', event => {
  if (event.key === 'ArrowUp' || event.key === 'ArrowDown') {
    event.preventDefault();
    historyIndex = Math.max(0, Math.min(history.length, historyIndex + (event.key === 'ArrowUp' ? -1 : 1)));
    commandInput.value = history[historyIndex] || '';
  }
});
