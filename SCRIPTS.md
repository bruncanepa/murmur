# 📜 Build Scripts Reference

Quick reference for all available build and run scripts.

## 🚀 Main Scripts (Use These!)

| Script | Purpose | Example |
|--------|---------|---------|
| `./dev.sh` | Development build & run | `./dev.sh` |
| `./prod.sh` | Production build & run | `./prod.sh` |

## 🔧 Additional Options

Both `dev.sh` and `prod.sh` accept these flags:

| Flag | Effect | Example |
|------|--------|---------|
| `--force` | Clean rebuild | `./dev.sh --force` |
| `--no-build` | Just restart, skip build | `./dev.sh --no-build` |

## 🛠️ Low-Level Scripts

| Script | Purpose | Example |
|--------|---------|---------|
| `./run.sh` | Generic runner | `./run.sh --dev` |
| `./build-app.sh` | Just build (no run) | `./build-app.sh --dev` |
| `./reset-permissions.sh` | Reset macOS permissions | `./reset-permissions.sh` |

## 📋 Examples

### Daily Development
```bash
# Most common - quick dev build
./dev.sh

# Having issues? Clean rebuild
./dev.sh --force

# Already built? Just restart
./dev.sh --no-build
```

### Production Build
```bash
# Build optimized version
./prod.sh

# Clean production build
./prod.sh --force
```

### Permission Issues
```bash
# Reset dev permissions
./reset-permissions.sh

# Reset production permissions
./reset-permissions.sh --prod

# Reset everything
./reset-permissions.sh --all

# Then rebuild
./dev.sh --force
```

### Both Versions
```bash
# Run dev and prod side-by-side
./dev.sh &
./prod.sh &
```

## 🆚 Dev vs Prod

| Aspect | Development | Production |
|--------|-------------|------------|
| **App Name** | `Murmur-Dev.app` | `Murmur.app` |
| **Bundle ID** | `com.murmur.app.dev` | `com.murmur.app` |
| **Build Config** | Debug (fast) | Release (optimized) |
| **Use Case** | Daily coding | Distribution |
| **Permissions** | Separate | Separate |

## 📚 More Info

For detailed documentation, see [BUILD.md](BUILD.md)
