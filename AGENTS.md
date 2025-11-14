# SketchyBar Configuration Agent Guidelines

## Build/Lint/Test Commands
- **Format**: `stylua config/lua/` (Lua formatter)
- **Lint**: `lua-language-server` for type checking and diagnostics
- **Build**: `nix build` to build the package
- **Shell**: `nix develop` to enter dev shell with lua-language-server and stylua

## Code Style Guidelines
- **Language**: Lua 5.4 for SketchyBar configuration
- **Imports**: Use `require("module")` for local modules, keep at top of file
- **Naming**: snake_case for variables and functions, PascalCase for modules
- **Formatting**: 2-space indentation, no trailing whitespace
- **Colors**: Use hex format with alpha (0xAARRGGBB), define in colors.lua
- **Icons**: Use NerdFont symbols, define in component files
- **Error Handling**: Check return values with pattern matching, use early returns
- **Structure**: Separate concerns - settings.lua, colors.lua, components/ for widgets
- **Comments**: Minimal, only for complex logic
- **File Organization**: Each component in separate file under components/