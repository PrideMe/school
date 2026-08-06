# AGENTS.md

## Diagnostic & Troubleshooting Guidelines
- **Strict Empirical Logging**: Never form diagnostic hypotheses or guess runtime failure root causes without empirical log evidence.
- **Log File Generation**: Always generate detailed file logs (`error.log`) on Windows startup detailing every step of window creation, engine initialization, and plugin registration.
- **Strict Evidence-Based Problem Solving**: Rely exclusively on logged runtime output and stack trace evidence when investigating errors.
