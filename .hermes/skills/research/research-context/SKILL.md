---
name: research-context
description: "Load when a task needs Yoann's research or HPC context."
version: 1.0.0
author: Yoann Pradat (via Hermes Agent)
license: MIT
platforms: [linux, macos]
metadata:
  hermes:
    tags: [Research, CancerGenomics, Bioinformatics, HPC, Context]
    related_skills: [bioinformatics, arxiv, grounded-citations]
---

# Research context

Standing background on the user's research domain, projects, and computing environment. This
material was moved out of `USER.md` so the always-injected user profile stays small. Load it when a
task touches these domains; there is no need to load it for unrelated operational work.

## When to Use

- Literature searches, monitoring, or synthesis in the user's domains (t-MN/AML/MDS, PARPi
  leukemogenesis, mutational signatures, cfDNA/ctDNA fragmentomics).
- Anything about the user's projects (tMN-PARPi, treatment resistance, fRagmentomics, sequencing
  pipelines, lecture processing).
- Planning or interpreting analyses where the computing environment matters (local Mac, conda envs,
  Slurm HPC, Singularity/Apptainer).
- Deciding which tool or knowledge store a piece of work belongs in (Notion, Obsidian, skills).

**This is stable background, not a task board.** Project status, deadlines, ownership, and active
work live in Notion. When they matter, retrieve current state from there rather than trusting this
file. Treat the project list as persistent themes.

## Background

- Yoann Pradat, French computational oncology and bioinformatics researcher.
- Current: postdoctoral researcher, Gustave Roussy, Elsa Bernard's team (Cancer Data Science).
- Prior: engineering training at Mines Paris; cancer genomics research at MSKCC; PhD in precision
  oncology and treatment resistance at Université Paris-Saclay.
- Works at the intersection of computational genomics, cancer biology, clinical
  oncology/hematology, statistics, and software engineering.

## Scientific interests

- Therapy-related myeloid neoplasms (t-MN), AML, MDS, MDS/MPN, clonal hematopoiesis.
- PARP inhibitor-associated leukemogenesis and treatment-related mutagenesis.
- Cancer evolution, clonal selection, treatment resistance.
- Somatic alterations: SNVs, indels, CNAs, SVs, complex rearrangements.
- Mutational signatures, chromothripsis, kataegis, telomere alterations, mobile-element insertions.
- cfDNA/ctDNA fragmentomics and molecular biomarkers.
- Translational cancer genomics and precision medicine.

Data modalities: WGS, WES, targeted sequencing, cfDNA/ctDNA, RNA-seq, single-cell sequencing.

## Main projects

- **tMN-PARPi / myeloid evolution** — genomic characterization of therapy-related myeloid
  malignancies: longitudinal WGS/WES, clonal evolution, mutational processes, treatment-associated
  alterations.
- **Treatment resistance** — genomic mechanisms of resistance, including T-DXd and longitudinal
  molecular profiling.
- **fRagmentomics** — R package for mutation-aware cfDNA fragment characterization and genotyping
  from sequencing alignments.
- **DNA sequencing pipelines** — reproducible somatic/germline alignment, variant calling,
  annotation, and genomic analysis workflows.
- **Scientific lecture processing** — automated transcription, detailed scientific extraction, and
  organization of oncology lectures and conference talks.

## Technical environment

**Local workstation** — MacBook Pro 14" (Mac14,5), Apple M2 Max 12-core, 32 GB RAM, macOS. iTerm2,
terminal, tmux, Git, Homebrew. Miniforge conda at `~/miniforge3` with many named envs (`py-parpi`,
`eacon`, `gsea-plotting`, `py-liftover`, `process-audio`, ...); R lives in those envs, not on the
base PATH. Ollama for local LLM experimentation; Whisper/faster-whisper for scientific audio
transcription.

**Institutional HPC** — Linux (Oracle Linux), Slurm, shared filesystems, CPU and GPU nodes
including A100/H100. No administrative/root privileges. Conda environments and
Singularity/Apptainer containers.

**Bioinformatics stack** — R, Python, Bash; Snakemake (primary) and Nextflow; samtools, bcftools,
GATK/Mutect2, Strelka2, SAGE, FreeBayes, VEP, FACETS/CNV tools; Git/GitHub, testing, benchmarking,
versioned environments.

Prefer existing infrastructure, explicit configuration, maintainable solutions, and minimal
unnecessary abstraction.

## Tools and organization

- **Hermes Agent** — autonomous research and organizational assistant: literature monitoring,
  project tracking, HPC monitoring, recurring tasks, summaries, workflow coordination.
- **OpenCode** — preferred terminal-based coding environment for repository inspection,
  development, refactoring, debugging, testing, and Git. "Ponytail" refers to the
  `glm-5.2-ponytail-lite` model variant (code-compression ruleset), not a separate tool.
- **Ollama / local LLMs** — transcript processing, summarization, experimentation.
- **ChatGPT** — research discussion, scientific reasoning, planning, writing.
- **Notion** — projects, tasks, meeting minutes, literature databases, conferences, people.
- **Obsidian** — personal Markdown knowledge base: prompts, LLM responses, technical notes,
  reusable knowledge. A separate laboratory vault may be developed later.

Preference: portable, searchable, interconnected knowledge systems that agents can work with.

## Long-term objective

An integrated, reproducible, AI-assisted research environment connecting research questions and
literature; projects, tasks, and notes; sequencing data, pipelines, and analyses; HPC monitoring
and automated workflows; figures, results, and manuscripts — reducing repetitive work while
retaining human oversight of consequential decisions.
