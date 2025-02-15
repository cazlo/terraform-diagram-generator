import subprocess
import sys
import click
import pydot

def dot_to_mermaid(dot_data: str) -> str:
    graphs = pydot.graph_from_dot_data(dot_data)
    if not graphs:
        sys.exit("Error: Unable to parse DOT data.")
    graph = graphs[0]
    mermaid_lines = ["flowchart LR"]
    node_ids = {}
    for node in graph.get_nodes():
        node_name = node.get_name().strip('"')
        if node_name in ("node", "graph"):
            continue
        safe_id = f"node_{len(node_ids)}"
        node_ids[node_name] = safe_id
        mermaid_lines.append(f"    {safe_id}[\"{node_name}\"]")
    for edge in graph.get_edges():
        src = edge.get_source().strip('"')
        dst = edge.get_destination().strip('"')
        if src not in node_ids:
            safe_id = f"node_{len(node_ids)}"
            node_ids[src] = safe_id
            mermaid_lines.append(f"    {safe_id}[\"{src}\"]")
        if dst not in node_ids:
            safe_id = f"node_{len(node_ids)}"
            node_ids[dst] = safe_id
            mermaid_lines.append(f"    {safe_id}[\"{dst}\"]")
        mermaid_lines.append(f"    {node_ids[src]} --> {node_ids[dst]}")
    return "\n".join(mermaid_lines)


@click.command()
@click.argument("path", type=click.Path(exists=True, file_okay=False))
def main(path):
    try:
        # todo would be nice to tf init if .terraform isnt there
        result = subprocess.run(
            ["terraform", "graph"],
            cwd=path,
            capture_output=True,
            text=True,
            check=True
        )
        dot_data = result.stdout
    except subprocess.CalledProcessError as e:
        sys.exit(f"Error running 'terraform graph': {e.stderr}")
    mermaid_flowchart = dot_to_mermaid(dot_data)
    click.echo(mermaid_flowchart)


if __name__ == "__main__":
    main()
