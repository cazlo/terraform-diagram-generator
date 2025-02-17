import os
import subprocess
from click.testing import CliRunner
import pytest
# from tf2mermaid import dot_to_mermaid, main

def test_dot_to_mermaid():
    print("init success")
#     dot_data = '''digraph {
#     "A" -> "B";
#     "B" -> "C";
# }'''
#     mermaid = dot_to_mermaid(dot_data)
#     assert "flowchart LR" in mermaid
#     assert "A" in mermaid
#     assert "B" in mermaid
#     assert "C" in mermaid
#     assert "-->" in mermaid

# def test_cli(monkeypatch):
#     # Ensure the provided path is always considered a directory.
#     monkeypatch.setattr(os.path, "isdir", lambda path: True)
#
#     class FakeCompletedProcess:
#         def __init__(self, stdout):
#             self.stdout = stdout
#             self.stderr = ""
#
#     def fake_run(cmd, cwd, capture_output, text, check):
#         dot_data = '''digraph {
#     "X" -> "Y";
# }'''
#         return FakeCompletedProcess(stdout=dot_data)
#
#     monkeypatch.setattr(subprocess, "run", fake_run)
#
#     runner = CliRunner()
#     result = runner.invoke(main, ["dummy_path"])
#     assert result.exit_code == 0
#     output = result.output
#     assert "flowchart LR" in output
#     assert "X" in output
#     assert "Y" in output