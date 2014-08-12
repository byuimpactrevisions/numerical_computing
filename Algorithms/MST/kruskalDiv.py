from operator import itemgetter

# Modified Kruskal's Algorithm
def kruskalDiv(edges, nodelist, div):
    removed = []
    nodes = {node:node for node in nodelist}
    remaining = len(nodes) - 1
    def track(node):
        temp = node
        while nodes[temp] is not temp:
            temp = nodes[temp]
        return temp
    for n1, n2, weight in sorted(edges, key=itemgetter(2)):
        root = track(n1)
        remove = track(n2)
        if root is not remove:
            removed.append(remove)
            remaining -=1
            nodes[remove] = root
            if remaining == div:
                return {node:track(node) for node in nodes}
            