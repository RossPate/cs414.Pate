//File: Assignment05/Problem1.cpp
// Description: Implement a binary search tree (BST) using std::variant to represent empty nodes and tree nodes
//  based on OCAML style example.
// Author: Ross Pate

#include <iostream>
#include <variant>
#include <memory>

struct Empty {};
struct Node;

using BST = std::variant<Empty, std::unique_ptr<Node>>;

struct Node {
    int value;
    BST left;
    BST right;

    Node(int v, BST l = Empty{}, BST r = Empty{})
        : value(v),
          left(std::move(l)),
          right(std::move(r)) {}
};

static std::unique_ptr<Node> make_node(int v, BST l = Empty{}, BST r = Empty{}) {
    return std::make_unique<Node>(v, std::move(l), std::move(r));
}

// local helper for std::visit pattern matching - got idea from AI
template<class... Ts> struct Overloaded : Ts... { using Ts::operator()...; };
template<class... Ts> Overloaded(Ts...) -> Overloaded<Ts...>;

void inorder(const BST& t) {
    std::visit(Overloaded{
        [](const Empty&) {},
        [&](const std::unique_ptr<Node>& p) {
            if (!p) return;
            inorder(p->left);
            std::cout << p->value << " ";
            inorder(p->right);
        }
    }, t);
}

void preorder(const BST& t) {
    std::visit(Overloaded{
        [](const Empty&) {},
        [&](const std::unique_ptr<Node>& p) {
            if (!p) return;
            std::cout << p->value << " ";
            preorder(p->left);
            preorder(p->right);
        }
    }, t);
}

void postorder(const BST& t) {
    std::visit(Overloaded{
        [](const Empty&) {},
        [&](const std::unique_ptr<Node>& p) {
            if (!p) return;
            postorder(p->left);
            postorder(p->right);
            std::cout << p->value << " ";
        }
    }, t);
}

int main() {
    BST t = make_node(5,
                 make_node(3, make_node(1), make_node(4)),
                 make_node(8, Empty{}, make_node(9)));

    std::cout << "Inorder: ";
    inorder(t);
    std::cout << "\nPreorder: ";
    preorder(t);
    std::cout << "\nPostorder: ";
    postorder(t);
    std::cout << std::endl;
}