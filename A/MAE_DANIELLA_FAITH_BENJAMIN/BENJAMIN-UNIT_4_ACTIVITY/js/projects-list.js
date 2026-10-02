// Project contents. Dynamically loads in Projects Section.

const PROJECTS = [
    {
        id: "aquaiman", name: "AquAIman", folder: "AquaAIman",
        role: "Front-end developer", period: "Jul - Aug 2026",
        status: "Top 5 Finalist, Open Category",
        stack: ["Random Forest Model", "React", "Leaflet.js", "Flask REST APIs"],
        summary: "A web-based predictive coastal intelligence system for assessing IUU fishing risk and supporting patrol prioritization in Northern Iloilo coastal areas.",
        overview: [
            "AquAIman helps coastal enforcement teams identify areas with higher potential IUU fishing risk using historical vessel and coastal activity data across seven Northern Iloilo municipalities.",
            "The system uses machine learning to classify areas into Low, Medium, and High risk levels, then presents the results through an interactive map and dashboard to make potential hotspots easier to identify and prioritize."
        ],
        contributions: [
            "Built the front end of the dashboard in React.",
            "Added the interactive map with Leaflet.js.",
            "Connected the interface to the Flask REST APIs.",
            "Implemented dashboard views for visualizing coastal risk information and patrol-prioritization data."
        ],
        shots: [
            ["Landing.png", "Landing page"],
            ["Login.png", "Login screen"],
            ["Report_Form.png", "Report form"],
            ["Enforcement_Dashboard.png", "Enforcement dashboard"]
        ]
    },
    {
        id: "reclaim", name: "Re:Claim", folder: "ReClaim",
        role: "Full-stack developer, QA analyst", period: "Jan - Apr 2026",
        status: "Live", link: ["reclaim.wvsu-usc.org", "https://reclaim.wvsu-usc.org"],
        stack: ["PHP", "MySQL", "JavaScript", "HTML/CSS", "Docker"],
        summary: "A lost and found tracking system for WVSU Main Campus that helps students report, search, and recover lost items.",
        overview: [
            "Before Re:Claim, lost-and-found concerns could be difficult to organize because item reports, descriptions, and recovery updates were handled through less centralized channels.",
            "Re:Claim gives students a centralized way to report lost or found items, browse listings, provide item details, and manage the recovery process through a web-based system."
        ],
        contributions: [
            "Developed both the front end and back end as a full-stack developer.",
            "Worked on the PHP MVC structure, database interactions, and user-facing pages.",
            "Tested the system as QA analyst and reported bugs before release.",
            "Implemented and refined lost-and-found item reporting and recovery-related workflows."
        ],
        shots: [
            ["Landing_Page.png", "Landing page"],
            ["Lost_Page.png", "Lost items page"],
            ["Posting_Form.png", "Item posting form"]
        ]
    },
    {
        id: "ljn-obdras", name: "LJN-OBDRAS", folder: "LJN-OBDRAS",
        role: "Full-stack developer, QA analyst", period: "Mar - Jun 2026",
        status: "Completed, awaiting deployment",
        stack: ["PHP", "MySQL", "JavaScript", "HTML/CSS"],
        summary: "An online document request and appointment system for Barangay Lopez Jaena Norte that digitizes certificate requests and appointment scheduling.",
        overview: [
            "Residents traditionally need to coordinate with the barangay to request documents and arrange appointments, which can involve repeated visits and manual processing.",
            "LJN-OBDRAS lets residents submit document requests without creating an account, upload required identification, select appointment slots, and track their requests using a Tracking ID. Barangay personnel can manage and process requests through an administrative system."
        ],
        contributions: [
            "Developed both the front end and back end as a full-stack developer.",
            "Built the multi-step document request flow and connected it to the database.",
            "Implemented appointment scheduling, request tracking, and document-related workflows.",
            "Tested the system as QA analyst and reported bugs before handover."
        ],
        shots: [
            ["Landing.png", "Landing page"],
            ["About.png", "About page"],
            ["Document_Stepper.png", "Document request stepper"],
            ["Request_Receipt.png", "Request receipt"],
            ["Request_Inbox.png", "Admin request inbox"],
            ["Admin_Login.png", "Admin login"]
        ]
    },
    {
        id: "bytelog", name: "ByteLog", folder: "Bytelog",
        role: "Full-stack Developer", period: "May 2025", status: "Completed",
        stack: ["PHP", "CSS", "JavaScript", "MySQL"],
        summary: "A digital student records system with separate Student, Teacher and Admin roles.",
        overview: [
            "ByteLog is designed to organize student records and school-related processes in one digital system for students, teachers, and administrators.",
            "Each role has access to functions suited to its responsibilities, allowing students to manage their information and enrollment-related tasks while teachers and administrators handle academic and administrative records."
        ],
        contributions: [
            "Developed the system as a full-stack developer.",
            "Worked on role-based features for Student, Teacher, and Admin users.",
            "Implemented the student enrollment module and related record-management workflows."
        ],
        shots: [
            ["Role_Selection.png", "Role selection"],
            ["Login.png", "Login screen"],
            ["Student_Homepage.png", "Student homepage"],
            ["Personal_Profile.png", "Personal profile"],
            ["Enrollment_Module.png", "Enrollment module"]
        ]
    },
    {
        id: "linkod", name: "Linkod", folder: "Linkod",
        role: "Full-stack Developer", period: "October 2025", status: "Completed",
        stack: ["HTML", "CSS", "JavaScript", "Bootstrap", "Tailwind CSS"],
        summary: "A community platform that connects people offering local skills and services with those who need them.",
        overview: [
            "Linkod addresses the difficulty of finding trusted local people who can provide specific skills or services within a community.",
            "Users can discover available skills and services, connect with providers, and participate in community-based exchanges through a centralized platform."
        ],
        contributions: [
            "Developed the web application as a full-stack developer.",
            "Worked on the skills and services section for discovering available community services.",
            "Implemented community-focused pages for organizing and presenting local users and services."
        ],
        shots: [
            ["Landing.png", "Landing page"],
            ["Skills.png", "Skills and services"],
            ["Communities.png", "Communities"]
        ]
    },
    {
        id: "tugma", name: "Tugma", folder: "Tugma",
        role: "Full-stack Developer", period: "May 2025", status: "Completed",
        stack: ["Java", "JavaFX", "MySQL"],
        summary: "A desktop application with a personality test that matches users to compatible characters.",
        overview: [
            "Tugma is a personality-based matching application designed to help users discover characters that share similar personality traits.",
            "Users answer a series of personality questions, receive a personality result, and can then explore character matches based on the compatibility of their results."
        ],
        contributions: [
            "Developed the desktop application as a full-stack developer.",
            "Implemented the personality test and result-generation flow.",
            "Worked on the character matching and match-result screens."
        ],
        shots: [
            ["Test_Question.png", "Personality test question"],
            ["Results_Personality.png", "Personality results"],
            ["Match_Finder.png", "Match finder"],
            ["Results_Match.png", "Match results"],
            ["Match_Profile.png", "Match profile"],
            ["Profile.png", "User profile"]
        ]
    }
];