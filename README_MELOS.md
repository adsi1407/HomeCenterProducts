Melos helper for this mono-repo

Using Melos v3

From Melos v3 the package is installed per-repository as a dev dependency next to `melos.yaml`.
You can run Melos using the `dart` runner without needing a global activation:

```powershell
# install dev deps (includes melos) for the repo
dart pub get

# run melos via dart
dart run melos --version
```

Useful commands (from repo root):

- Bootstrap (install deps for all packages and link path deps):

```powershell
dart run melos bootstrap
```

- Run `flutter pub get` across all packages:

```powershell
dart run melos exec -c 1 -- flutter pub get
```

- Run tests across all packages:

```powershell
dart run melos exec -c 1 -- flutter test
```

- Update deps across all packages (careful):

```powershell
dart run melos exec -c 1 -- dart pub upgrade
```

Tips
- Use `dart run melos exec -c N` to run commands in parallel up to N packages.
- To bump a package version and update references, explore `dart run melos version` and `dart run melos publish`.

Windows PATH notes
------------------
If you activated Melos with `dart pub global activate melos`, the executable is placed in your pub cache bin directory, for example:

`C:\Users\<YourUser>\AppData\Local\Pub\Cache\bin`

Make sure that folder is in your PATH. Two quick options:

- Add to current PowerShell session (temporary):

```powershell
$env:PATH += ";$env:USERPROFILE\AppData\Local\Pub\Cache\bin"
```

- Persist for your user (permanent):

```powershell
[Environment]::SetEnvironmentVariable('PATH', $env:PATH + ';' + "$env:USERPROFILE\AppData\Local\Pub\Cache\bin", 'User')
# Close and reopen your terminal (or sign out/in) for the change to take effect
```

Verification
------------
After opening a new terminal, verify Melos is available:

```powershell
# shows melos path(s)
where melos

# shows melos version
melos --version
```

If `where melos` finds nothing (you still prefer global activation), ensure the path above exactly matches your pub cache location and retry the steps.
