defmodule NervesSystemEv3.MixProject do
  use Mix.Project

  @app :nerves_system_ev3
  @version Path.join(__DIR__, "VERSION")
           |> File.read!()
           |> String.trim()

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.4",
      compilers: Mix.compilers() ++ [:nerves_package],
      nerves_package: nerves_package(),
      description: description(),
      package: package(),
      deps: deps(),
      aliases: [loadconfig: [&bootstrap/1], docs: ["docs", &copy_images/1]],
      docs: [extras: ["README.md"], main: "readme"]
    ]
  end

  def application do
    []
  end

  defp bootstrap(args) do
    System.put_env("MIX_TARGET", "ev3")
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  defp nerves_package do
    [
      type: :system,
      artifact_sites: [
        {:github_releases, "nerves-project/#{@app}"}
      ],
      platform: Nerves.System.BR,
      platform_config: [
        defconfig: "nerves_defconfig"
      ],
      checksum: package_files()
    ]
  end

  defp deps do
    [
      {:nerves, "~> 1.0", runtime: false},
      {:nerves_system_br, "1.4.5", runtime: false},
      {:nerves_toolchain_armv5tejl_unknown_linux_musleabi, "1.1.0", runtime: false},
      {:nerves_system_linter, "~> 0.3.0", runtime: false},
      {:ex_doc, "~> 0.18", only: :dev}
    ]
  end

  defp description do
    """
    Nerves System - Lego Mindstorms EV3 http://www.lego.com/en-us/mindstorms/about-ev3
    """
  end

  defp package do
    [
      maintainers: ["Frank Hunleth", "Justin Schneck"],
      files: package_files(),
      licenses: ["Apache 2.0"],
      links: %{"Github" => "https://github.com/nerves-project/#{@app}"}
    ]
  end

  defp package_files do
    [
      "fwup_include",
      "package",
      "rootfs_overlay",
      "CHANGELOG.md",
      "Config.in",
      "external.mk",
      "fwup-revert.conf",
      "fwup.conf",
      "LICENSE",
      "linux-4.4-ev3dev.defconfig",
      "mix.exs",
      "nerves_defconfig",
      "nerves_logo_178x128.pbm",
      "post-build.sh",
      "post-createfs.sh",
      "README.md",
      "VERSION"
    ]
  end

  # Copy the images referenced by docs, since ex_doc doesn't do this.
  defp copy_images(_) do
    File.cp_r("assets", "doc/assets")
  end
end
