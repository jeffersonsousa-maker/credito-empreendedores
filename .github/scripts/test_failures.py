"""Mostra as falhas dos testes como anotações do GitHub Actions.

Lê o relatório JSON gerado por `flutter test --file-reporter json:<arquivo>`
e cria uma anotação de erro por teste que falhou, com a mensagem do erro e o
que o teste imprimiu. As anotações aparecem no resumo da execução, sem
precisar abrir o log completo.
"""

import json
import sys

MAX_ANNOTATIONS = 10
MAX_ERROR = 1800
MAX_OUTPUT = 1800


def escape_data(text: str) -> str:
    return text.replace("%", "%25").replace("\r", "%0D").replace("\n", "%0A")


def escape_prop(text: str) -> str:
    return escape_data(text).replace(":", "%3A").replace(",", "%2C")


def main(path: str) -> None:
    names: dict[int, str] = {}
    prints: dict[int, list[str]] = {}
    errors: dict[int, list[str]] = {}
    failed: list[int] = []

    with open(path, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if not line.startswith("{"):
                continue
            try:
                event = json.loads(line)
            except json.JSONDecodeError:
                continue
            kind = event.get("type")
            if kind == "testStart":
                test = event["test"]
                names[test["id"]] = test.get("name", "")
            elif kind == "print":
                prints.setdefault(event["testID"], []).append(event.get("message", ""))
            elif kind == "error":
                errors.setdefault(event["testID"], []).append(event.get("error", ""))
            elif kind == "testDone":
                if event.get("result") != "success" and not event.get("hidden"):
                    failed.append(event["testID"])

    print(f"{len(failed)} teste(s) falharam.")
    for test_id in failed[:MAX_ANNOTATIONS]:
        name = names.get(test_id, f"teste {test_id}")
        error = "\n".join(errors.get(test_id, []))[:MAX_ERROR]
        output = "\n".join(prints.get(test_id, []))[:MAX_OUTPUT]
        message = f"{error}\n--- saída ---\n{output}" if output else error
        print(f"::error title={escape_prop(name)}::{escape_data(message)}")


if __name__ == "__main__":
    main(sys.argv[1])
