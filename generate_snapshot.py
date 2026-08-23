# ============================================================
# SPACE EDUOS
# NOTEBOOKLM SMART SNAPSHOT GENERATOR v3
# PYTHON VERSION
# ============================================================
#
# DEFAULT:
#
#   python generate_snapshot.py
#
# Akan menghasilkan:
#
#   Documents/kode_full_TC/
#
#   ├── LIB_core.md
#   ├── LIB_features.md
#   ├── LIB_models.md
#   ├── LIB_providers.md
#   ├── LIB_services.md
#   ├── LIB_ROOT.md
#   └── PROJECT_CONFIG.md
#
# Sistem SMART:
#
# - Folder yang berubah  -> diperbarui
# - Folder tidak berubah -> tidak ditulis ulang
# - SHA-256 digunakan untuk mendeteksi perubahan
#
# ============================================================

import hashlib
import json
import sys
from datetime import datetime
from pathlib import Path


# ============================================================
# 1. PROJECT ROOT
# ============================================================

PROJECT_ROOT = Path.cwd()

PUBSPEC_FILE = PROJECT_ROOT / "pubspec.yaml"

if not PUBSPEC_FILE.exists():

    print()
    print("=" * 70)
    print("ERROR: pubspec.yaml tidak ditemukan!")
    print("=" * 70)
    print()
    print("Pastikan terminal berada di ROOT project Flutter.")
    print()
    print(r"Contoh:")
    print(r"cd C:\Users\Thinkpad\Documents\Space_EduOS")
    print("python generate_snapshot.py")
    print()

    raise SystemExit(1)


# ============================================================
# 2. OUTPUT
# ============================================================

OUTPUT_DIR = (
        Path.home()
        / "Documents"
        / "kode_full_TC"
)

OUTPUT_DIR.mkdir(
    parents=True,
    exist_ok=True
)


# ============================================================
# 3. MANIFEST
# ============================================================

MANIFEST_FILE = (
        OUTPUT_DIR
        / ".snapshot_manifest.json"
)


# ============================================================
# 4. FOLDER LIB
# ============================================================

LIB_DIR = (
        PROJECT_ROOT
        / "lib"
)


# ============================================================
# 5. FILE PROJECT CONFIG
# ============================================================

PROJECT_CONFIG_FILES = [

    "pubspec.yaml",

    "analysis_options.yaml",

    "README.md",

    "CHANGELOG.md",

]


# ============================================================
# 6. FOLDER PROJECT CONFIG
# ============================================================

PROJECT_CONFIG_DIRECTORIES = [

    "supabase",

    "docs",

    "test",

    "integration_test",

]


# ============================================================
# 7. EXTENSION YANG DIIZINKAN
# ============================================================

ALLOWED_EXTENSIONS = {

    ".dart",

    ".yaml",

    ".yml",

    ".sql",

    ".md",

    ".json",

}


# ============================================================
# 8. FOLDER YANG DIABAIKAN
# ============================================================

EXCLUDED_DIRECTORIES = {

    ".git",

    ".dart_tool",

    "build",

    ".idea",

    ".vscode",

    "node_modules",

    ".gradle",

    ".pub-cache",

    "coverage",

    "dist",

    "out",

    "bin",

    "obj",

    "Pods",

    "__pycache__",

}


# ============================================================
# 9. FILE SENSITIF
# ============================================================

EXCLUDED_FILES = {

    ".env",

    ".env.local",

    ".env.production",

    ".env.development",

    ".env.example",

    "google-services.json",

    "GoogleService-Info.plist",

}


# ============================================================
# 10. KEYWORD SENSITIF
# ============================================================

SENSITIVE_KEYWORDS = {

    "secret",

    "credential",

    "password",

    "private_key",

    "service_account",

    "service-account",

}


# ============================================================
# 11. TIMESTAMP
# ============================================================

def current_timestamp():

    return datetime.now().strftime(
        "%Y-%m-%d %H:%M:%S"
    )


# ============================================================
# 12. RELATIVE PATH
# ============================================================

def relative_path(path: Path):

    try:

        return path.relative_to(
            PROJECT_ROOT
        ).as_posix()

    except ValueError:

        return path.as_posix()


# ============================================================
# 13. CEK EXCLUDED PATH
# ============================================================

def is_excluded_path(path: Path):

    parts = {

        part.lower()

        for part in path.parts

    }

    return any(

        excluded.lower() in parts

        for excluded
        in EXCLUDED_DIRECTORIES

    )


# ============================================================
# 14. CEK FILE SENSITIF
# ============================================================

def is_sensitive_file(path: Path):

    filename = path.name.lower()

    # Exact filename

    for excluded in EXCLUDED_FILES:

        if filename == excluded.lower():

            return True

    # Keyword

    for keyword in SENSITIVE_KEYWORDS:

        if keyword in filename:

            return True

    return False


# ============================================================
# 15. CEK FILE VALID
# ============================================================

def is_allowed_file(path: Path):

    if not path.is_file():

        return False

    if path.suffix.lower() not in ALLOWED_EXTENSIONS:

        return False

    if is_excluded_path(path):

        return False

    if is_sensitive_file(path):

        return False

    return True


# ============================================================
# 16. MARKDOWN LANGUAGE
# ============================================================

def markdown_language(path: Path):

    extension = path.suffix.lower()

    if extension == ".dart":

        return "dart"

    if extension in {".yaml", ".yml"}:

        return "yaml"

    if extension == ".sql":

        return "sql"

    if extension == ".json":

        return "json"

    if extension == ".md":

        return "markdown"

    return ""


# ============================================================
# 17. SAFE FILE NAME
# ============================================================

def safe_filename(name):

    return (

        name

        .replace("\\", "_")

        .replace("/", "_")

        .replace(" ", "_")

    )


# ============================================================
# 18. SHA256 FILE
# ============================================================

def sha256_file(path: Path):

    sha256 = hashlib.sha256()

    with open(
            path,
            "rb"
    ) as file:

        while True:

            chunk = file.read(
                1024 * 1024
            )

            if not chunk:

                break

            sha256.update(
                chunk
            )

    return sha256.hexdigest()


# ============================================================
# 19. HASH SATU SCOPE
# ============================================================

def calculate_scope_hash(files):

    entries = []

    for path in sorted(

            files,

            key=lambda p:
            relative_path(p).lower()

    ):

        entries.append({

            "path":
                relative_path(path),

            "size":
                path.stat().st_size,

            "sha256":
                sha256_file(path),

        })

    payload = json.dumps(

        entries,

        sort_keys=True,

        ensure_ascii=False,

    ).encode("utf-8")

    scope_hash = hashlib.sha256(
        payload
    ).hexdigest()

    return scope_hash, entries


# ============================================================
# 20. LOAD MANIFEST
# ============================================================

def load_manifest():

    if not MANIFEST_FILE.exists():

        return {

            "version": 3,

            "scopes": {}

        }

    try:

        with open(

                MANIFEST_FILE,

                "r",

                encoding="utf-8"

        ) as file:

            data = json.load(file)

        if not isinstance(
                data,
                dict
        ):

            raise ValueError()

        data.setdefault(
            "version",
            3
        )

        data.setdefault(
            "scopes",
            {}
        )

        return data

    except Exception:

        print(
            "[WARNING] Manifest rusak. "
            "Membuat manifest baru."
        )

        return {

            "version": 3,

            "scopes": {}

        }


# ============================================================
# 21. SAVE MANIFEST
# ============================================================

def save_manifest(manifest):

    temp_file = (
        MANIFEST_FILE
        .with_suffix(".tmp")
    )

    with open(

            temp_file,

            "w",

            encoding="utf-8"

    ) as file:

        json.dump(

            manifest,

            file,

            indent=2,

            ensure_ascii=False

        )

    temp_file.replace(
        MANIFEST_FILE
    )


# ============================================================
# 22. KUMPULKAN FILE FOLDER
# ============================================================

def collect_directory_files(
        directory: Path
):

    files = []

    if not directory.exists():

        return files

    if directory.is_file():

        if is_allowed_file(
                directory
        ):

            files.append(
                directory
            )

        return files

    for path in directory.rglob("*"):

        if not path.is_file():

            continue

        if not is_allowed_file(
                path
        ):

            continue

        files.append(path)

    return sorted(

        set(files),

        key=lambda p:
        relative_path(p).lower()

    )


# ============================================================
# 23. KUMPULKAN SEMUA FOLDER LIB
# ============================================================

def collect_lib_scopes():

    scopes = {}

    if not LIB_DIR.exists():

        print(
            "[WARNING] Folder lib/ tidak ditemukan."
        )

        return scopes


    # --------------------------------------------------------
    # FILE LANGSUNG DI DALAM LIB
    # --------------------------------------------------------

    root_files = []

    for path in LIB_DIR.iterdir():

        if path.is_file():

            if is_allowed_file(path):

                root_files.append(
                    path
                )


    if root_files:

        scopes["LIB_ROOT"] = sorted(

            root_files,

            key=lambda p:
            relative_path(p).lower()

        )


    # --------------------------------------------------------
    # FOLDER DI DALAM LIB
    # --------------------------------------------------------

    for directory in sorted(

            LIB_DIR.iterdir(),

            key=lambda p:
            p.name.lower()

    ):

        if not directory.is_dir():

            continue

        if (
                directory.name
                in EXCLUDED_DIRECTORIES
        ):

            continue

        files = collect_directory_files(
            directory
        )

        if not files:

            continue

        scope_name = (

                "LIB_"

                + safe_filename(
            directory.name
        )

        )

        scopes[scope_name] = files


    return scopes


# ============================================================
# 24. KUMPULKAN PROJECT CONFIG
# ============================================================

def collect_project_config():

    files = []


    # --------------------------------------------------------
    # ROOT CONFIG
    # --------------------------------------------------------

    for filename in PROJECT_CONFIG_FILES:

        path = (
                PROJECT_ROOT
                / filename
        )

        if (

                path.exists()

                and is_allowed_file(path)

        ):

            files.append(path)


    # --------------------------------------------------------
    # FOLDER CONFIG
    # --------------------------------------------------------

    for directory_name in (
            PROJECT_CONFIG_DIRECTORIES
    ):

        directory = (
                PROJECT_ROOT
                / directory_name
        )

        if not directory.exists():

            continue

        files.extend(

            collect_directory_files(
                directory
            )

        )


    return sorted(

        set(files),

        key=lambda p:
        relative_path(p).lower()

    )


# ============================================================
# 25. TULIS HEADER
# ============================================================

def write_header(

        outfile,

        scope_name,

        files,

        scope_hash

):

    outfile.write(
        "# Space EduOS — NotebookLM Source Snapshot\n\n"
    )

    outfile.write(
        f"**Scope:** `{scope_name}`  \n"
    )

    outfile.write(
        f"**Generated:** "
        f"{current_timestamp()}  \n"
    )

    outfile.write(
        f"**Total Files:** "
        f"{len(files)}  \n"
    )

    outfile.write(
        f"**SHA-256:** "
        f"`{scope_hash}`\n\n"
    )

    outfile.write(
        "---\n\n"
    )

    outfile.write(
        "## Included Files\n\n"
    )

    for path in files:

        outfile.write(

            f"- `{relative_path(path)}`\n"

        )

    outfile.write(
        "\n---\n\n"
    )

    outfile.write(
        "# Source Code\n\n"
    )


# ============================================================
# 26. TULIS SOURCE FILE
# ============================================================

def write_source(

        outfile,

        path

):

    content = path.read_text(

        encoding="utf-8",

        errors="replace"

    )

    size = path.stat().st_size

    lines = len(
        content.splitlines()
    )

    language = markdown_language(
        path
    )

    rel = relative_path(
        path
    )

    outfile.write(
        "---\n\n"
    )

    outfile.write(
        f"## FILE: `{rel}`\n\n"
    )

    outfile.write(
        f"**Size:** "
        f"{size / 1024:.2f} KB  \n"
    )

    outfile.write(
        f"**Lines:** "
        f"{lines}\n\n"
    )

    outfile.write(
        f"```{language}\n"
    )

    outfile.write(
        content
    )

    if not content.endswith(
            "\n"
    ):

        outfile.write(
            "\n"
        )

    outfile.write(
        "```\n\n"
    )

    return lines, size


# ============================================================
# 27. TULIS FOOTER
# ============================================================

def write_footer(

        outfile,

        scope_name,

        files,

        total_lines,

        total_bytes,

        scope_hash

):

    outfile.write(
        "---\n\n"
    )

    outfile.write(
        "# Snapshot Statistics\n\n"
    )

    outfile.write(
        f"- Scope: `{scope_name}`\n"
    )

    outfile.write(
        f"- Total files: "
        f"{len(files)}\n"
    )

    outfile.write(
        f"- Total lines: "
        f"{total_lines}\n"
    )

    outfile.write(
        f"- Total size: "
        f"{total_bytes / 1024 / 1024:.2f} MB\n"
    )

    outfile.write(
        f"- SHA-256: "
        f"`{scope_hash}`\n"
    )

    outfile.write(
        f"- Generated: "
        f"{current_timestamp()}\n\n"
    )

    outfile.write(
        "**END OF SNAPSHOT**\n"
    )


# ============================================================
# 28. PROCESS SCOPE
# ============================================================

def process_scope(

        scope_name,

        files,

        old_manifest

):

    print()
    print(
        "-" * 70
    )

    print(
        f"SCOPE: {scope_name}"
    )

    print(
        "-" * 70
    )

    scope_hash, entries = (
        calculate_scope_hash(
            files
        )
    )

    output_file = (
            OUTPUT_DIR
            / f"{scope_name}.md"
    )

    previous = (
        old_manifest
        .get("scopes", {})
        .get(scope_name)
    )


    # ========================================================
    # TIDAK BERUBAH
    # ========================================================

    if (

            previous

            and previous.get("hash")
            == scope_hash

            and output_file.exists()

    ):

        print(
            "STATUS : TIDAK BERUBAH"
        )

        print(
            f"FILE   : "
            f"{output_file}"
        )

        return {

            "status":
                "unchanged",

            "hash":
                scope_hash,

            "entries":
                entries,

            "file":
                str(output_file),

        }


    # ========================================================
    # BERUBAH
    # ========================================================

    print(
        "STATUS : DIUPDATE"
    )

    print(
        f"FILE   : "
        f"{output_file}"
    )

    total_lines = 0
    total_bytes = 0

    temp_file = (
        output_file
        .with_suffix(".tmp")
    )


    with open(

            temp_file,

            "w",

            encoding="utf-8"

    ) as outfile:

        write_header(

            outfile,

            scope_name,

            files,

            scope_hash

        )

        for index, path in enumerate(

                files,

                start=1

        ):

            try:

                lines, size = (
                    write_source(
                        outfile,
                        path
                    )
                )

                total_lines += lines

                total_bytes += size

                print(

                    f"  [{index}/{len(files)}] "
                    f"{relative_path(path)}"

                )

            except Exception as error:

                print(

                    f"  [ERROR] "
                    f"{relative_path(path)}: "
                    f"{error}"

                )

        write_footer(

            outfile,

            scope_name,

            files,

            total_lines,

            total_bytes,

            scope_hash

        )


    temp_file.replace(
        output_file
    )


    return {

        "status":
            "updated",

        "hash":
            scope_hash,

        "entries":
            entries,

        "file":
            str(output_file),

    }


# ============================================================
# 29. CLEANUP SCOPE YANG SUDAH DIHAPUS
# ============================================================

def cleanup_deleted_scopes(

        old_manifest,

        current_scopes

):

    old_scopes = set(

        old_manifest
        .get("scopes", {})
        .keys()

    )

    current_scopes = set(
        current_scopes
    )

    deleted_scopes = (
            old_scopes
            - current_scopes
    )


    for scope_name in deleted_scopes:

        output_file = (
                OUTPUT_DIR
                / f"{scope_name}.md"
        )

        if output_file.exists():

            try:

                output_file.unlink()

                print(

                    f"[CLEANUP] "
                    f"Menghapus: "
                    f"{output_file.name}"

                )

            except Exception as error:

                print(

                    f"[WARNING] "
                    f"Gagal menghapus "
                    f"{output_file}: "
                    f"{error}"

                )


# ============================================================
# 30. MAIN
# ============================================================

def main():

    arguments = [

        arg.strip()

        for arg in sys.argv[1:]

        if arg.strip()

    ]


    print()

    print(
        "=" * 70
    )

    print(
        "SPACE EDUOS — NOTEBOOKLM SMART SNAPSHOT v3"
    )

    print(
        "=" * 70
    )

    print()

    print(
        f"Project : "
        f"{PROJECT_ROOT}"
    )

    print(
        f"Output  : "
        f"{OUTPUT_DIR}"
    )

    print()


    # ========================================================
    # DEFAULT
    # ========================================================

    if not arguments:

        print(
            "MODE    : SMART LIB + PROJECT CONFIG"
        )

        print()

        scopes = (
            collect_lib_scopes()
        )

        project_config = (
            collect_project_config()
        )

        if project_config:

            scopes[
                "PROJECT_CONFIG"
            ] = project_config


    # ========================================================
    # MANUAL
    # ========================================================

    else:

        print(
            "MODE    : SELECTED TARGET"
        )

        print(
            "TARGET  : "
            + ", ".join(arguments)
        )

        print()

        scopes = {}


        for argument in arguments:

            target = (
                    PROJECT_ROOT
                    / argument
            )

            if not target.exists():

                print(

                    f"[WARNING] "
                    f"Tidak ditemukan: "
                    f"{argument}"

                )

                continue


            files = (
                collect_directory_files(
                    target
                )
            )

            if not files:

                continue


            scope_name = safe_filename(

                argument

                .replace(
                    "/",
                    "_"
                )

                .replace(
                    "\\",
                    "_"
                )

            )


            if target.is_file():

                scope_name = (
                        "FILE_"
                        + safe_filename(
                    target.stem
                )
                )

            else:

                scope_name = (
                        "SNAPSHOT_"
                        + scope_name
                )


            scopes[
                scope_name
            ] = files


    # ========================================================
    # VALIDASI
    # ========================================================

    if not scopes:

        print()

        print(
            "ERROR: "
            "Tidak ada file ditemukan!"
        )

        print()

        raise SystemExit(1)


    # ========================================================
    # MANIFEST
    # ========================================================

    old_manifest = (
        load_manifest()
    )

    new_manifest = {

        "version":
            3,

        "project":
            str(PROJECT_ROOT),

        "generated":
            current_timestamp(),

        "scopes":
            {}

    }


    # ========================================================
    # PROCESS
    # ========================================================

    updated = 0

    unchanged = 0


    for scope_name in sorted(

            scopes.keys(),

            key=str.lower

    ):

        result = process_scope(

            scope_name,

            scopes[scope_name],

            old_manifest

        )


        new_manifest[
            "scopes"
        ][scope_name] = {

            "hash":
                result["hash"],

            "file":
                result["file"],

            "entries":
                result["entries"],

        }


        if result["status"] == "updated":

            updated += 1

        else:

            unchanged += 1


    # ========================================================
    # CLEANUP
    # ========================================================

    if not arguments:

        cleanup_deleted_scopes(

            old_manifest,

            scopes.keys()

        )


    # ========================================================
    # SAVE MANIFEST
    # ========================================================

    save_manifest(
        new_manifest
    )


    # ========================================================
    # SUMMARY
    # ========================================================

    print()

    print(
        "=" * 70
    )

    print(
        "SMART SNAPSHOT SELESAI"
    )

    print(
        "=" * 70
    )

    print()

    print(
        f"Total scope   : "
        f"{len(scopes)}"
    )

    print(
        f"Diupdate      : "
        f"{updated}"
    )

    print(
        f"Tidak berubah : "
        f"{unchanged}"
    )

    print()

    print(
        "OUTPUT:"
    )

    print(
        OUTPUT_DIR
    )

    print()

    print(
        "MANIFEST:"
    )

    print(
        MANIFEST_FILE
    )

    print()

    print(
        "Selesai."
    )

    print()


# ============================================================
# RUN
# ============================================================

if __name__ == "__main__":

    main()