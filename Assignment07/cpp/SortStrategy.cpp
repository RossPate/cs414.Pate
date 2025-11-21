// 
// File: SortStrategy.cpp
// Description: Implementation of various sorting strategies 
//              using the SortStrategy abstract base class.
// Author: Ross Pate
//

#include <iostream>
#include <vector>
#include <algorithm>
#include <chrono>
#include <functional>
#include <string>
#include <iomanip>

class SortStrategy {
public:
    virtual ~SortStrategy() = default;
    virtual void sort(std::vector<int>& data) = 0;
    virtual std::string name() const = 0;
};

class QuickSort : public SortStrategy {
private:
    int partition(std::vector<int>& arr, int low, int high) {
        int pivot = arr[high];
        int i = low - 1;
        
        for (int j = low; j < high; j++) {
            if (arr[j] < pivot) {
                i++;
                std::swap(arr[i], arr[j]);
            }
        }
        std::swap(arr[i + 1], arr[high]);
        return i + 1;
    }
    
    void quicksort(std::vector<int>& arr, int low, int high) {
        if (low < high) {
            int pi = partition(arr, low, high);
            quicksort(arr, low, pi - 1);
            quicksort(arr, pi + 1, high);
        }
    }
    
public:
    void sort(std::vector<int>& data) override {
        if (!data.empty()) {
            quicksort(data, 0, data.size() - 1);
        }
    }
    
    std::string name() const override { return "QuickSort"; }
};

class MergeSort : public SortStrategy {
private:
    void merge(std::vector<int>& arr, int left, int mid, int right) {
        int n1 = mid - left + 1;
        int n2 = right - mid;
        
        std::vector<int> L(n1), R(n2);
        
        for (int i = 0; i < n1; i++)
            L[i] = arr[left + i];
        for (int j = 0; j < n2; j++)
            R[j] = arr[mid + 1 + j];
        
        int i = 0, j = 0, k = left;
        
        while (i < n1 && j < n2) {
            if (L[i] <= R[j]) {
                arr[k++] = L[i++];
            } else {
                arr[k++] = R[j++];
            }
        }
        
        while (i < n1) arr[k++] = L[i++];
        while (j < n2) arr[k++] = R[j++];
    }
    
    void mergesort(std::vector<int>& arr, int left, int right) {
        if (left < right) {
            int mid = left + (right - left) / 2;
            mergesort(arr, left, mid);
            mergesort(arr, mid + 1, right);
            merge(arr, left, mid, right);
        }
    }
    
public:
    void sort(std::vector<int>& data) override {
        if (!data.empty()) {
            mergesort(data, 0, data.size() - 1);
        }
    }
    
    std::string name() const override { return "MergeSort"; }
};

class BubbleSort : public SortStrategy {
public:
    void sort(std::vector<int>& data) override {
        int n = data.size();
        for (int i = 0; i < n - 1; i++) {
            bool swapped = false;
            for (int j = 0; j < n - i - 1; j++) {
                if (data[j] > data[j + 1]) {
                    std::swap(data[j], data[j + 1]);
                    swapped = true;
                }
            }
            if (!swapped) break;
        }
    }
    
    std::string name() const override { return "BubbleSort"; }
};

class LambdaStrategy : public SortStrategy {
private:
    std::function<void(std::vector<int>&)> func;
    std::string strategyName;
    
public:
    LambdaStrategy(std::function<void(std::vector<int>&)> f, const std::string& name)
        : func(f), strategyName(name) {}
    
    void sort(std::vector<int>& data) override {
        func(data);
    }
    
    std::string name() const override { return strategyName; }
};

class SortContext {
private:
    SortStrategy* strategy;
    
public:
    SortContext() : strategy(nullptr) {}
    
    void set_strategy(SortStrategy* strat) {
        strategy = strat;
    }
    
    void execute_strategy(std::vector<int>& data, bool print_time = false) {
        if (!strategy) {
            std::cout << "No strategy set!\n";
            return;
        }
        
        auto start = std::chrono::high_resolution_clock::now();
        strategy->sort(data);
        auto end = std::chrono::high_resolution_clock::now();
        
        auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
        
        if (print_time) {
            std::cout << std::left << std::setw(15) << strategy->name() 
                      << " - Time: " << duration.count() << " μs\n";
        }
    }
};

void print_vector(const std::vector<int>& data) {
    std::cout << "[";
    for (size_t i = 0; i < data.size(); i++) {
        std::cout << data[i];
        if (i < data.size() - 1) std::cout << ", ";
    }
    std::cout << "]\n";
}

std::vector<int> generate_random_data(int size, int max_val = 1000) {
    std::vector<int> data(size);
    for (int& val : data) {
        val = rand() % max_val;
    }
    return data;
}

int main() {
    SortContext context;
    QuickSort quick;
    MergeSort merge;

    std::vector<int> data = {5, 2, 9, 1, 5, 6};

    context.set_strategy(&quick);
    context.execute_strategy(data);  // QuickSort

    context.set_strategy(&merge);
    context.execute_strategy(data);  // MergeSort
    
    return 0;
}