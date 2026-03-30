# Binaural Beats - Open Source Brainwave Entrainment

## Enterprise Project Documentation

**Version:** 1.0  
**Date:** March 28, 2026  
**License:** MIT (Documentation)  

---

## 📋 Overview

This repository contains comprehensive enterprise-grade documentation for an open-source, cross-platform Binaural Beats application built with Flutter. The documentation covers market analysis, scientific research, product strategy, technical specifications, and quality assurance validation.

### Project Vision

Democratize access to scientifically-backed brainwave entrainment technology through a free, open-source, cross-platform application that prioritizes user wellbeing over profit.

---

## 📁 Documentation Structure

```
binaural-beats-app-docs/
├── README.md                          # This file
├── docs/
│   ├── prd/
│   │   └── product_requirements_document.md    # Comprehensive PRD
│   ├── tech_specs/
│   │   └── technical_specifications.md         # Technical architecture
│   ├── research/
│   │   ├── market_analysis.md                  # Competitive analysis
│   │   ├── neuroscience_audio_research.md      # Scientific foundation
│   │   └── product_strategy.md                 # Roadmap & monetization
│   ├── diagrams/
│   │   ├── system_architecture.mmd             # High-level architecture
│   │   ├── audio_pipeline.mmd                  # Audio processing flow
│   │   ├── audio_engine_detail.mmd             # FFI implementation
│   │   ├── sequence_flow.mmd                   # User interaction flow
│   │   ├── state_management.mmd                # App state architecture
│   │   ├── er_diagram.mmd                      # Database schema
│   │   ├── auth_flow.mmd                       # Authentication flow
│   │   └── ci_cd_pipeline.mmd                  # Deployment pipeline
│   ├── qa/
│   │   └── validation_report.md                # QA feasibility review
│   └── architecture/
│       └── (placeholder for additional diagrams)
├── assets/
│   └── (placeholder for images/assets)
└── src/
    └── (placeholder for source code references)
```

---

## 🎯 Key Features (Planned)

### Core Audio
- Real-time binaural beat synthesis using pure sine waves
- Five scientifically-validated brainwave bands:
  - **Delta** (0.5-4 Hz): Deep sleep, healing
  - **Theta** (4-8 Hz): Meditation, creativity
  - **Alpha** (8-12 Hz): Relaxation, stress relief
  - **Beta** (12-30 Hz): Focus, concentration
  - **Gamma** (30-100 Hz): Higher cognition
- Customizable carrier frequencies (100-500 Hz)
- Background music mixing
- Gapless looping with fade in/out

### User Experience
- Clean, minimal interface
- One-tap preset selection
- Session timer with presets
- Save favorite combinations
- Cross-platform consistency
- Dark/light themes
- Full accessibility support

### Ethical Monetization
- **100% Free:** Core functionality never paywalled
- **Donation-First:** GitHub Sponsors, Open Collective integration
- **Dormant Ads:** Strictly off-by-default, remotely toggleable
- **Transparent:** Public financial reports

---

## 🏗️ Technology Stack

### Frontend (Mobile App)
| Component | Technology |
|-----------|------------|
| Framework | Flutter 3.19+ |
| Language | Dart 3.3+ |
| State Management | Riverpod 2.5+ |
| Audio Engine | flutter_soloud (FFI) |
| Local Storage | Hive |
| Backend Client | Supabase Flutter |

### Backend
| Component | Technology |
|-----------|------------|
| Platform | Supabase |
| Database | PostgreSQL 15+ |
| Authentication | GoTrue (built-in) |
| Functions | Deno Edge |
| Real-time | Elixir/Phoenix |

### Admin Dashboard
| Component | Technology |
|-----------|------------|
| Framework | React 18+ |
| Styling | Tailwind CSS |
| Charts | Recharts |
| Hosting | Vercel (free tier) |

---

## 💰 Cost Analysis

### Free Tier Limits (Supabase)
| Resource | Limit | Est. Users Supported |
|----------|-------|---------------------|
| Database | 500 MB | ~10,000 users |
| Auth | 50K MAU | 50,000 monthly |
| Bandwidth | 2 GB | ~5,000 active |
| Storage | 1 GB | Sufficient |

### Projected Costs
| Stage | Users | Monthly Cost |
|-------|-------|--------------|
| Development | 0 | $0 |
| Launch | 1,000 | $0 |
| Growth | 10,000 | $25 |
| Scale | 50,000 | $25-50 |

**Conclusion:** Sustainable zero-cost operation up to 10K users, minimal costs beyond.

---

## 📊 Market Position

### Target Market Gap
- No fully open-source, cross-platform binaural beats app exists
- All competitors are proprietary or platform-locked
- Scientific accuracy often sacrificed for marketing
- Subscription fatigue creates demand for free alternatives

### Competitive Advantages
1. **Open Source:** Full transparency, community-driven
2. **Scientific:** Peer-reviewed frequency presets
3. **Ethical:** Donation-first, dormant ads
4. **Cross-Platform:** Single codebase, all platforms

---

## 🔬 Scientific Foundation

All frequency presets are based on peer-reviewed research:

### Key Research Sources
- Frontiers in Digital Health (2025): Brainwave entrainment methods
- PMC7082494: Binaural beats through auditory pathway
- PMC6761229: Brain activity correlates with cognitive performance
- Oster (1973): Auditory beats in the brain

### Frequency Guidelines
| Band | Range | Best For |
|------|-------|----------|
| Delta | 0.5-4 Hz | Deep sleep, healing |
| Theta | 4-8 Hz | Meditation, creativity |
| Alpha | 8-12 Hz | Relaxation, calm focus |
| Beta | 12-30 Hz | Active focus, productivity |
| Gamma | 30-100 Hz | Higher cognition, memory |

---

## 🚀 Development Roadmap

### Phase 1: Foundation (Months 1-3)
- [ ] Core audio engine with flutter_soloud
- [ ] Five brainwave presets
- [ ] Basic UI with frequency controls
- [ ] Background playback
- [ ] Supabase backend setup
- [ ] Cross-platform builds

### Phase 2: Enhancement (Months 4-6)
- [ ] Save/load custom presets
- [ ] Session timer and history
- [ ] Donation integration
- [ ] Music mixing
- [ ] Settings and preferences
- [ ] Community preset sharing

### Phase 3: Advanced (Months 7-9)
- [ ] Isochronic tones
- [ ] Audio visualization
- [ ] Health app integration
- [ ] Smart recommendations
- [ ] Accessibility improvements

### Phase 4: Scale (Months 10-12)
- [ ] Desktop platforms
- [ ] Advanced analytics
- [ ] Professional/therapist features
- [ ] API access
- [ ] White-label options

---

## 📖 Documentation Guide

### For Product Managers
Start with:
1. [Market Analysis](docs/research/market_analysis.md)
2. [Product Strategy](docs/research/product_strategy.md)
3. [Product Requirements Document](docs/prd/product_requirements_document.md)

### For Developers
Start with:
1. [Technical Specifications](docs/tech_specs/technical_specifications.md)
2. [Diagrams](docs/diagrams/)
3. [PRD Technical Sections](docs/prd/product_requirements_document.md)

### For Researchers
Start with:
1. [Neuroscience & Audio Research](docs/research/neuroscience_audio_research.md)
2. [Market Analysis](docs/research/market_analysis.md)

### For QA/Testing
Start with:
1. [QA Validation Report](docs/qa/validation_report.md)
2. [Technical Specifications](docs/tech_specs/technical_specifications.md)

---

## 🔧 Mermaid Diagrams

All system diagrams are provided as standalone `.mmd` files in `docs/diagrams/`:

| Diagram | Purpose |
|---------|---------|
| `system_architecture.mmd` | High-level system components |
| `audio_pipeline.mmd` | Audio processing flow |
| `audio_engine_detail.mmd` | FFI implementation detail |
| `sequence_flow.mmd` | User interaction sequence |
| `state_management.mmd` | App state architecture |
| `er_diagram.mmd` | Database entity relationships |
| `auth_flow.mmd` | Authentication sequence |
| `ci_cd_pipeline.mmd` | Deployment pipeline |

View these diagrams using:
- [Mermaid Live Editor](https://mermaid.live)
- GitHub (native rendering)
- VS Code with Mermaid extension

---

## ✅ Quality Assurance

The documentation has passed comprehensive QA validation:

| Check | Status |
|-------|--------|
| Cross-document consistency | ✅ Passed |
| Technical feasibility | ✅ Passed |
| Mermaid syntax validation | ✅ All 8 diagrams valid |
| Cost model verification | ✅ Zero-cost confirmed |
| Security review | ✅ Passed |
| Compliance check | ✅ GDPR/CCPA ready |

See [QA Validation Report](docs/qa/validation_report.md) for details.

---

## 🤝 Contributing

This is a documentation repository. For the actual application development:

1. Fork the repository (when created)
2. Create a feature branch
3. Follow the PRD and Tech Specs
4. Submit pull requests

### Documentation Contributions
- Report inconsistencies via issues
- Suggest improvements via pull requests
- Validate diagrams render correctly

---

## 📜 License

This documentation is licensed under the MIT License.

The actual application code (when developed) will also be MIT licensed.

---

## 🙏 Acknowledgments

### Research Sources
- Frontiers in Digital Health
- PubMed Central (PMC)
- ScienceDirect
- Academic journals on brainwave entrainment

### Technology
- Flutter Team (Google)
- Supabase Team
- SoLoud Audio Engine
- Open source community

---

## 📧 Contact

- **Project:** Binaural Beats Open Source
- **Repository:** (To be created)
- **Discussions:** GitHub Discussions (when available)
- **Donations:** GitHub Sponsors / Open Collective (when available)

---

## 📝 Document Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-03-28 | Initial release |

---

**Built with ❤️ for the open-source community.**
