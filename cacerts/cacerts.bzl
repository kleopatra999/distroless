"""A rule to unpack ca certificates from the debian package."""

def _impl(ctx):
    args = "%s %s %s" % (ctx.executable._extract.path, ctx.file.deb.path, ctx.outputs.out.path)
    ctx.action(command = args,
            inputs = [ctx.executable._extract, ctx.file.deb],
            outputs = [ctx.outputs.out])

load("@package_bundle//file:packages.bzl", "packages")

cacerts = rule(
    attrs = {
        "deb": attr.label(
            default = Label(packages["ca-certificates"]),
            allow_files = [".deb"],
            single_file = True,
        ),
        # Implicit dependencies.
        "_extract": attr.label(
            default = Label("//cacerts:extract_certs"),
            cfg = "host",
            executable = True,
            allow_files = True,
        ),
    },
    executable = False,
    outputs = {
        "out": "%{name}.tar",
    },
    implementation = _impl,
)
