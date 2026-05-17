# Isochores Detection Using Bayesian Model Comparison

## Overview
This repository contains an academic project completed as part of the course **Bayesian Statistics**.

An organism’s genetic information is encoded in its cells in DNA molecules, organized into structures called chromosomes. DNA molecules are polymers that consist of a long chain of monomers, which are called nucleotides. Each nucleotide contains a nitrogenous base. There are four types of bases: adenine (A), guanine (G), cytosine (C), and thymine (T).

Isochores are regions (segments of the chain) of a specific chromosome in which the percentage of bases of type C or G is approximately constant.

The data folder contains 5 datasets, each consisting of 100 consecutive observations concerning the number of bases of type C or G in windows composed of 5000 bases each. 

The goal is to determine whether each dataset originates from one or two different isochores. 

## Datasets
Each dataset is a vector containing the counts of C or G bases in consecutive windows, each of which consists of 5,000 bases.

# 📊 Bayesian Model Comparison for Isochore Detection

## 📌 Problem Description

Each dataset consists of \( n = 100 \) observations

\[
x = (x_i)_{i=1}^n
\]

where each observation \( x_i \) represents the number of nucleotides of type **C or G** within genomic windows of length

\[
m = 5000 \text{ bases}
\]

The observations are sequential and correspond to consecutive genomic windows along a DNA segment.

The goal is to determine whether each dataset originates from:

- a **single isochore (homogeneous genomic region)**, or  
- **two different isochores (a structural change in GC-content)**.

---

## 🧬 Statistical Modeling

We assume that each base behaves independently, and that the probability of observing a C or G base is constant within a given region.

Thus, each observation follows a Binomial model:

\[
x_i \mid \theta \sim \text{Binomial}(m, \theta), \quad i = 1,2,\dots,n
\]

where:
- \( m = 5000 \)
- \( \theta \) is the GC-content probability.

---

## 📈 Competing Models

### 🟦 Model \( M_1 \): Single Isochore

The entire sequence comes from one homogeneous region:

\[
x_i \sim \text{Binomial}(m, \theta), \quad \forall i = 1,\dots,n
\]

---

### 🟧 Model \( M_2 \): Two Isochores (Change-Point Model)

There exists an unknown change point \( t \in \{1,2,\dots,n-1\} \) such that:

\[
x_i \sim \text{Binomial}(m, \theta_1), \quad i = 1,\dots,t
\]

\[
x_i \sim \text{Binomial}(m, \theta_2), \quad i = t+1,\dots,n
\]

This represents a structural shift in GC-content along the sequence.

---

## 🎯 Bayesian Framework

To compare the two models, we use a Bayesian approach.

### Priors:

- Model probabilities:
\[
P(M_1) = P(M_2) = \frac{1}{2}
\]

- Parameter priors:
\[
\theta \sim \mathcal{U}(0,1), \quad
\theta_1 \sim \mathcal{U}(0,1), \quad
\theta_2 \sim \mathcal{U}(0,1)
\]

- Change-point prior:
\[
t \sim \mathcal{U}\{1,2,\dots,n-1\}
\]

---

## 🧪 Objective

For each dataset, we compute and compare the posterior probabilities of:

- \( M_1 \): single isochore model  
- \( M_2 \): two-isochore change-point model  

to determine whether a structural change in GC-content is supported by the data.

---

## 📌 Output

For each dataset, the analysis determines whether:

- The sequence is best explained by a **single isochore**, or  
- There is evidence of a **change point indicating two isochores**. 
