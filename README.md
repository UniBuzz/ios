<div align="center">
  <h1>SmokeLess</h1>
</div>

## Getting Started

### 1. Commit Message Convention

This repository follows [Conventional Commit](https://www.conventionalcommits.org/en/v1.0.0/)
#### Format
`<type>(optional scope): <description>`
Contoh: `feat(dashboard): add button`

#### Type:

Type yang bisa digunakan adalah:

- feat → Kalo ada penambahan/pengurangan codingan
- fix → kalo ada bug fixing
- BREAKING CHANGE → kalo ada perubahan yang signifikan (ubah login flow)
- docs → update documentation (README.md)
- styling → update styling, ga ngubah logic sama sekali (reorder import, benerin whitespace)
- ci → update github workflow
- test → update testing
- perf → fix sesuatu yang bersifat cuma untuk performance issue (derived state, memo)

#### Optional Scope:

Contoh labeling per page `feat(dashboard): add button`

*kalo gaada scopenya, gausa ditulis.


#### Description:

Description harus bisa mendeskripsikan apa yang dikerjakan. Jika ada beberapa hal yang dikerjakan, maka lakukan commit secara bertahap.

- Setelah titik dua, ada spasi. Contoh: `feat: add something`
- Kalo type `fix` langsung sebut aja issuenya apa. Contoh:  `fix: file size limiter not working`
- Gunakan kata imperative, present tense: "change" bukan "changed" atau "changes"
- Gunakan huruf kecil di semua description. Jangan berikan huruf besar di depan kalimat
- Jangan tambahkan titik di akhir description

### 2. Branch Naming Rules
> **IMPORTANT:**  
> - Agar Terintegrasi dengan JIRA maka gunakan format branch seperti contoh dibawah
> - Jika ingin menyelesaikan lebih dari 1 backlog di jira bisa dengan contoh urutan kedua dibawah
> - Gunakan lowercase dan ubah spasi backlog menjadi dash / '-'

- SST-xx-lorem-ipsum-dolor-amit
- SST-xx-SST-yy-SST-zz-lorem-ipsum

### 3. Pull Request Title Naming Rules
> **IMPORTANT:**  
> - Agar Terintegrasi dengan JIRA maka gunakan format penamaan pull request seperti contoh dibawah
> - Jika ingin menyelesaikan lebih dari 1 backlog di jira bisa dengan contoh urutan kedua dibawah
> - Gunakan Squash & Merge dan mengganti commit sesuai aturan conventional commit pada poin #3 di README

- SST-xx "lorem ipsum"
- SST-xx SST-yy SST-zz "lorem-ipsum"
