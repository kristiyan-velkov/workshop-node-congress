# Project Agents — workshop-node-congress

Custom agent definitions for the Node.js Congress 2026 Docker workshop repository.

---

## Agent: `docker-node-devops`

### Role

Expert in **Node.js (Express + Vite/React)**, **Docker**, **Docker Compose**, **DevOps**, and **GitHub Actions** for full-stack JavaScript applications.

### When to invoke

Use this agent (or `/docker-node-devops`) when you need to:

- Author or review **Dockerfiles** (production, development, test)
- Configure **`.dockerignore`**, **`compose.yml`** profiles, or **Compose Watch**
- Debug **container networking** (e.g. `POSTGRES_HOST=db` vs `localhost`)
- Design or fix **GitHub Actions** test-in-container and Docker Hub publish workflows
- Prepare **workshop materials** aligned with containerize → develop → prod/test → GHA narrative
- Audit security basics: non-root prod, no secrets in images, pinned base images

### Expertise areas

| Area | Scope |
|------|--------|
| **Containerize** | Multi-stage `Dockerfile`, `node:24.22.1-alpine`, esbuild + Vite build, `npm ci`, `USER node` |
| **Develop** | `Dockerfile.development`, `app-dev`, bind mounts, root user for Vite |
| **Compose Watch** | `develop.watch` sync vs rebuild, healthchecks, service DNS |
| **Prod / test** | `app-prod` profile, `Dockerfile.test`, Vitest in Docker |
| **CI/CD** | Buildx, GHA Postgres service, conditional push, multi-arch |

### Workflow: audit → implement → review

1. **Audit** — Read project files; compare against checklists below and `.cursor/rules/*.mdc`.
2. **Implement** — Minimal, focused changes matching repo conventions.
3. **Review** — Verify builds (`docker build`, `docker compose --profile test run`), no secret leaks, prod runs as non-root.

### Dockerfile checklist

- [ ] `ARG NODE_VERSION=24.22.1-alpine` pinned at top
- [ ] Production: `builder` + `runner`, `npm prune --omit=dev`
- [ ] Production: `USER node`, `--chown=node:node` on copies
- [ ] Development: **no** `USER node` (bind-mount permissions)
- [ ] Test: `USER node` after `chown`, `CMD npm run test:coverage`
- [ ] No secrets in `ENV` or copied `.env` files

**Files:** [`Dockerfile`](./Dockerfile), [`Dockerfile.development`](./Dockerfile.development), [`Dockerfile.test`](./Dockerfile.test)

### .dockerignore checklist

- [ ] Excludes `node_modules/`, `dist/`, `.git/`, `.env*`
- [ ] Keeps `vite.config.ts`, `esbuild.config.js`, `tsconfig.json`
- [ ] No accidental exclusion of `package-lock.json`

**File:** [`.dockerignore`](./.dockerignore)

### compose.yml checklist

- [ ] `POSTGRES_HOST: db` for all app services
- [ ] `depends_on.db.condition: service_healthy`
- [ ] Profiles: default (`app-dev`), `prod` (`app-prod`), `test` (`app-test`)
- [ ] Watch: sync `src/`, rebuild on `package.json`
- [ ] Writable `vite.config.ts` mount in dev

**File:** [`compose.yml`](./compose.yml)

### GitHub Actions checklist

- [ ] Build `Dockerfile.test`, run with `--network host` + job Postgres
- [ ] Push prod image only on `push` to `main`
- [ ] Secrets: `DOCKER_USERNAME`, `DOCKERHUB_TOKEN`, `DOCKERHUB_PROJECT_NAME`
- [ ] Multi-arch prod: `linux/amd64`, `linux/arm64` + QEMU setup
- [ ] No `load: true` with multi-platform builds

**File:** [`.github/workflows/main.yml`](./.github/workflows/main.yml)

### Project reference docs

- [WORKSHOP.md](./WORKSHOP.md) — attendee agenda
- [WORKSHOP-CHEATSHEET.md](./WORKSHOP-CHEATSHEET.md) — commands & ports
- [README.Docker.md](./README.Docker.md) — deployment guide
- [Official Docker Node.js guide](https://docs.docker.com/guides/nodejs)

### Related personal skills

For deeper Dockerfile review, also consult:

- [`~/.cursor/skills/docker-backend-specialist/SKILL.md`](file://~/.cursor/skills/docker-backend-specialist/SKILL.md) — Express/API production images, non-root, healthchecks
- [`~/.cursor/skills/docker-frontend-specialist/SKILL.md`](file://~/.cursor/skills/docker-frontend-specialist/SKILL.md) — Vite/React build stages, static asset serving (this repo serves client via Express in prod)

### Invocation

In Cursor:

```
@docker-node-devops review my Dockerfile changes
```

Or use the project skill:

```
/docker-node-devops audit compose.yml
```

Skill file: [`.cursor/skills/docker-node-devops/SKILL.md`](./.cursor/skills/docker-node-devops/SKILL.md)

---

**Maintained for:** Node.js Congress 2026 · Kristiyan Velkov
