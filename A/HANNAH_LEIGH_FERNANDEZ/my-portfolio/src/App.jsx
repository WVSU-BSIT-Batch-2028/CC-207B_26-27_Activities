import { useEffect, useRef, useState } from 'react'
import './App.css'

const me = {
  title: 'Web Developer',
  script: 'portfolio',
  year: 'Information',
  name: 'Hannah Leigh Fernandez',
  role: 'Hello! I am a beginner Front-end web developer.',
  email: 'hannahleigh.fernandez@wvsu.edu.ph',
  about: [
    'I am a student of West Visayas State University - Main Campus, currently pursuing a Bachelor of Science in Information Technology (BSIT). I have a strong interest in graphic and layout design and have been honing my skills in this field through various projects and coursework. I am interested in creating websites that are accessible and user-friendly while also allowing you to showcase your full personality. I believe that we are capable of bringing websites that fully express personality without compromising on functionality and accessibility.',],
  skills: ['Typography', 'Brand identity', 'Layout & editorial', 'Illustration', 'Figma', 'Frontend: HTML, CSS, JavaScript, React', 'Live2D animation', 'Motion graphics', 'Video editing'],
  links: [
    { label: 'GitHub', href: 'https://github.com/idiaphile' },
    { label: 'LinkedIn', href: 'https://www.linkedin.com/in/hannah-leigh-fernandez' },
    { label: 'Résumé (PDF)', href: 'https://fernandez-resume.tiiny.site' },
  ],
}

const TABS = ['About', 'Skills', 'Contact']

function App() {
  const [theme, setTheme] = useState(() => {
    const savedTheme = localStorage.getItem('portfolio-theme')
    return savedTheme || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')
  })
  const [open, setOpen] = useState(false)
  const [tab, setTab] = useState(0)
  const [focusedTab, setFocusedTab] = useState(0)
  const openBtn = useRef(null)
  const tabRefs = useRef([])
  const mounted = useRef(false)
  const infoRef = useRef(null)
  const [fitHeight, setFitHeight] = useState(undefined)

  // For theme
  function toggleTheme() {
    const nextTheme = theme === 'light' ? 'dark' : 'light'
    localStorage.setItem('portfolio-theme', nextTheme)
    setTheme(nextTheme)
  }

  // Animates the folder height when the content gets longer or shorter
  useEffect(() => {
    const el = infoRef.current
    if (!el || typeof ResizeObserver === 'undefined') return
    const ro = new ResizeObserver(() => setFitHeight(el.offsetHeight))
    ro.observe(el)
    return () => ro.disconnect()
  }, [])

  // For focus management
  useEffect(() => {
    if (!mounted.current) {
      mounted.current = true
      return
    }
    if (open) tabRefs.current[tab]?.focus({ preventScroll: true })
    else openBtn.current?.focus({ preventScroll: true })
  }, [open])

  // Allows keyboard to navigate between tabs
  function onTabKey(e) {
    const n = TABS.length
    const currentTab = tabRefs.current.findIndex((ref) => ref === document.activeElement)
    let i = currentTab >= 0 ? currentTab : focusedTab
    if (e.key === 'ArrowRight') i = (i + 1) % n
    else if (e.key === 'ArrowLeft') i = (i + n - 1) % n
    else if (e.key === 'Home') i = 0
    else if (e.key === 'End') i = n - 1
    else return
    e.preventDefault()
    setFocusedTab(i)
    tabRefs.current[i]?.focus()
  }

  return (
    <main className="app" data-theme={theme} onKeyDown={(e) => e.key === 'Escape' && open && setOpen(false)}>
      <header className="toolbar">
        <button
          className="theme-toggle"
          type="button"
          onClick={toggleTheme}
          aria-label={`Switch to ${theme === 'light' ? 'dark' : 'light'} mode`}
          title={`Switch to ${theme === 'light' ? 'dark' : 'light'} mode`}
        >
          {theme === 'light' ? (
            <svg viewBox="0 0 24 24" aria-hidden="true">
              <path d="M12 3v2m0 14v2M5.64 5.64l1.42 1.42m9.88 9.88 1.42 1.42M3 12h2m14 0h2M5.64 18.36l1.42-1.42m9.88-9.88 1.42-1.42M16 12a4 4 0 1 1-8 0 4 4 0 0 1 8 0Z" />
            </svg>
          ) : (
            <svg viewBox="0 0 24 24" aria-hidden="true">
              <path d="M20.2 15.2A8.5 8.5 0 0 1 8.8 3.8 8.5 8.5 0 1 0 20.2 15.2Z" />
            </svg>
          )}
        </button>
      </header>

      <h1 className="visually-hidden">{me.title} {me.script}: {me.name}</h1>

      <div className={`stage ${open ? 'is-open' : ''}`}>

        {/* Back folder*/}
        <div className="back-tab" aria-hidden="true">{me.year}</div>
        <div className="back">
          <div className="back-fit" style={{ height: fitHeight }}>
          <section ref={infoRef} id="folder-content" className="info" aria-label="Portfolio contents">
            <div className="info-bar">
              <div role="tablist" aria-label="Portfolio sections" onKeyDown={onTabKey}>
                {TABS.map((t, i) => (
                  <button
                    key={t}
                    ref={(el) => (tabRefs.current[i] = el)}
                    type="button"
                    role="tab"
                    id={`tab-${i}`}
                    aria-selected={tab === i}
                    aria-controls={`panel-${i}`}
                    tabIndex={focusedTab === i ? 0 : -1}
                    onFocus={() => setFocusedTab(i)}
                    onClick={() => setTab(i)}
                  >
                    {t}
                  </button>
                ))}
              </div>
              <button type="button" className="btn btn-quiet" onClick={() => setOpen(false)}>
                Close folder
              </button>
            </div>

            <div role="tabpanel" id={`panel-${tab}`} aria-labelledby={`tab-${tab}`} tabIndex={0} className="panel">
              {tab === 0 && (
                <>
                  <h2>About me: Hannah Leigh Fernandez!</h2>
                  <p className="lede">{me.role}</p>
                  {me.about.map((p) => <p key={p}>{p}</p>)}
                </>
              )}
              {tab === 1 && (
                <>
                  <h2>Skills</h2>
                  <ul className="chips">
                    {me.skills.map((s) => <li key={s}>{s}</li>)}
                  </ul>
                </>
              )}
              {tab === 2 && (
                <>
                  <h2>Contact</h2>
                  <p>I'm looking for a summer design internship. Email is the quickest way to reach me.</p>
                  <p><a className="btn" href={`mailto:${me.email}`}>Email {me.email}</a></p>
                  <ul className="link-list">
                    {me.links.map((l) => (
                      <li key={l.label}>
                        <a href={l.href} target="_blank" rel="noopener noreferrer">
                          {l.label === 'GitHub' ? (
                            <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                              <path fill="currentColor" d="M12 .5C5.65.5.5 5.65.5 12c0 5.1 3.3 9.4 7.9 10.9.6.1.8-.3.8-.6v-2.1c-3.2.7-3.9-1.4-3.9-1.4-.5-1.3-1.3-1.6-1.3-1.6-1.1-.8.1-.8.1-.8 1.2.1 1.8 1.3 1.8 1.3 1.1 1.8 2.8 1.3 3.5 1 .1-.8.4-1.3.7-1.6-2.6-.3-5.3-1.3-5.3-5.8 0-1.3.5-2.3 1.2-3.1-.1-.3-.5-1.5.1-3.1 0 0 1-.3 3.2 1.2a11.2 11.2 0 0 1 5.8 0c2.2-1.5 3.2-1.2 3.2-1.2.6 1.6.2 2.8.1 3.1.8.8 1.2 1.8 1.2 3.1 0 4.5-2.7 5.5-5.3 5.8.4.3.7 1 .7 2v2.7c0 .3.2.7.8.6A11.5 11.5 0 0 0 23.5 12C23.5 5.65 18.35.5 12 .5Z" />
                            </svg>
                          ) : l.label === 'LinkedIn' ? (
                            <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                              <path fill="currentColor" d="M20.45 20.45h-3.55v-5.57c0-1.33-.03-3.04-1.85-3.04-1.85 0-2.13 1.44-2.13 2.94v5.67H9.37V9h3.41v1.56h.05c.47-.9 1.63-1.85 3.36-1.85 3.59 0 4.26 2.36 4.26 5.43v6.31ZM5.36 7.43a2.06 2.06 0 1 1 0-4.12 2.06 2.06 0 0 1 0 4.12ZM7.14 20.45H3.58V9h3.56v11.45ZM22.22 0H1.77C.79 0 0 .77 0 1.72v20.56C0 23.23.79 24 1.77 24h20.45c.98 0 1.78-.77 1.78-1.72V1.72C24 .77 23.2 0 22.22 0Z" />
                            </svg>
                          ) : (
                            <svg className="resume-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                              <path d="M6 2.75h7l5 5v13.5H6zM13 2.75v5h5M9 12h6M9 15.5h6M9 19h4" />
                            </svg>
                          )}
                          {l.label}
                        </a>
                      </li>
                    ))}
                  </ul>
                </>
              )}
            </div>
          </section>
          </div>
        </div>

        {/* Front folder */}
        <div className="front">
          <span className="front-tab" aria-hidden="true">{me.name}</span>
          <p className="title" aria-hidden="true">
            <span className="big">{me.title}</span>
            <span className="script">{me.script}</span>
          </p>
          <button
            ref={openBtn}
            type="button"
            className="btn open-btn"
            aria-expanded={open}
            aria-controls="folder-content"
            onClick={() => setOpen(true)}
          >
            Tap to open folder <span aria-hidden="true">↓</span>
          </button>
        </div>
      </div>
    </main>
  )
}

export default App