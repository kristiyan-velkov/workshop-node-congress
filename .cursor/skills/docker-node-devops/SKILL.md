---
name: docker-node-devops
description: >-
  Expert in Node.js (Express + Vite/React), Docker, Docker Compose, DevOps, and
  GitHub Actions for full-stack JavaScript apps. Use when containerizing,
  configuring Compose Watch, writing prod/test Dockerfiles, fixing CI/CD
  workflows, or preparing the workshop-node-congress Docker workshop.
---

# Docker Node DevOps Skill

Production-oriented Docker and CI/CD guidance for **workshop-node-congress**: Express 5 API, React 19 (Vite), PostgreSQL, esbuild, Vitest.

## When to use

- Creating or reviewing `Dockerfile`, `Dockerfile.development`, `Dockerfile.test`
- Editing `.dockerignore` or `compose.yml` (profiles, Watch, healthchecks)
- Debugging `POSTGRES_HOST`, CORS, Vite EACCES, or port mapping issues
- Authoring/fixing `.github/workflows/main.yml` (test container + Hub push)
- Workshop prep aligned with: **containerize → develop → prod/test → GHA**

## Expertise

| Topic | Key artifacts |
|-------|----------------|
| Containerize | Multi-stage `Dockerfile`, `node:24.16.0-alpine`, `npm ci`, `USER node` |
| Develop | `Dockerfile.development`, `app-dev`, Compose Watch |
| Prod | `--profile prod`, `app-prod`, single-port Express |
| Test | `Dockerfile.test`, `app-test`, Vitest coverage |
| CI/CD | Buildx cache, GHA Postgres service, conditional push |

## Workflow

### 1. Audit

Read:

```bash
cat Dockerfile Dockerfile.development Dockerfile.test .dockerignore compose.yml
cat .github/workflows/main.yml
```

Compare against `.cursor/rules/*.mdc` and checklists below.

### 2. Implement

- Match existing repo tone and file layout.
- Minimal diffs; no unrelated refactors.
- Dev image stays **root**; prod/test use **`USER node`**.

### 3. Review

```bash
docker build -t todoapp:local .
docker compose up app-dev --watch    # dev smoke
docker compose --profile prod up app-prod --build -d
docker compose --profile test run --rm --build app-test
```

## Checklists

### Dockerfile

- [ ] `ARG NODE_VERSION=24.16.0-alpine`
- [ ] Prod: builder → runner, `npm run build`, `npm prune --omit=dev`
- [ ] Prod: `ENTRYPOINT ["node", "dist/server.js"]`, `USER node`
- [ ] Dev: `CMD ["npm", "run", "dev:docker"]`, no `USER node`
- [ ] Test: `CMD ["npm", "run", "test:coverage"]`, `CI=true`

### .dockerignore

- [ ] Exclude `node_modules`, `dist`, `.git`, `.env*`, `coverage`
- [ ] Keep `vite.config.ts`, `esbuild.config.js`, lockfile

### compose.yml

- [ ] `POSTGRES_HOST: db` (not `localhost`)
- [ ] `depends_on: db: condition: service_healthy`
- [ ] Profiles: `prod` → `app-prod`, `test` → `app-test`
- [ ] Watch sync on `./src`, rebuild on `package.json`

### GitHub Actions

- [ ] Test job: `Dockerfile.test` + `docker run --network host`
- [ ] Push: only `github.event_name == 'push' && github.ref == 'refs/heads/main'`
- [ ] Secrets: `DOCKER_USERNAME`, `DOCKERHUB_TOKEN`, `DOCKERHUB_PROJECT_NAME`
- [ ] Multi-arch prod + `setup-qemu-action`; test image `linux/amd64` + `load: true`

## Project files

| File | Purpose |
|------|---------|
| `Dockerfile` | Production multi-stage |
| `Dockerfile.development` | Dev hot reload |
| `Dockerfile.test` | Vitest in CI/Compose |
| `compose.yml` | app-dev / app-prod / app-test / db |
| `.github/workflows/main.yml` | Test + conditional push |

## Docs

- [WORKSHOP.md](../../WORKSHOP.md)
- [WORKSHOP-CHEATSHEET.md](../../WORKSHOP-CHEATSHEET.md)
- [README.Docker.md](../../README.Docker.md)
- [Docker Node.js guide](https://docs.docker.com/guides/nodejs)
- [.ai/AGENTS.md](../../.ai/AGENTS.md)

## Related personal skills

- `/docker-backend-specialist` — Express/API Dockerfile hardening (~/.cursor/skills/docker-backend-specialist)
- `/docker-frontend-specialist` — Vite/React build patterns (~/.cursor/skills/docker-frontend-specialist)

## Usage examples

```
/docker-node-devops audit Dockerfile for production readiness
/docker-node-devops fix compose.yml POSTGRES_HOST for app-dev
/docker-node-devops review .github/workflows/main.yml push conditions
```
