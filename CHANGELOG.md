# Changelog

## [Unreleased](https://github.com/defra/waste-exemptions-back-office/tree/HEAD)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v4.0.1...HEAD)

**Implemented enhancements:**

- Feature/ruby 4204 wex restoring monthly back office data export [\#2019](https://github.com/DEFRA/waste-exemptions-back-office/pull/2019) ([brujeo](https://github.com/brujeo))
- \[RUBY-4179\] Add rake tasks for cleaning up duplicate and orphan addresses [\#2009](https://github.com/DEFRA/waste-exemptions-back-office/pull/2009) ([brujeo](https://github.com/brujeo))
- \[RUBY-4119\] Remove applicant details from registration and renewals journeys [\#2005](https://github.com/DEFRA/waste-exemptions-back-office/pull/2005) ([jjromeo](https://github.com/jjromeo))
- Feature/ruby 3906 wex bo service analytics dashboard changes [\#2001](https://github.com/DEFRA/waste-exemptions-back-office/pull/2001) ([brujeo](https://github.com/brujeo))

**Fixed bugs:**

- \[RUBY-4194\] Fix charge amount calculation for multisite registrations in finance export [\#2012](https://github.com/DEFRA/waste-exemptions-back-office/pull/2012) ([brujeo](https://github.com/brujeo))
- \[RUBY-4196\] Fix bug with incorrect site details being shown for multiple sites [\#2011](https://github.com/DEFRA/waste-exemptions-back-office/pull/2011) ([jjromeo](https://github.com/jjromeo))

**Merged pull requests:**

- \[RUBY-4177\] Update exemption codes in charging schemes JSON seed data [\#2017](https://github.com/DEFRA/waste-exemptions-back-office/pull/2017) ([jjromeo](https://github.com/jjromeo))
- Bump waste\_exemptions\_engine from `9fed6d9` to `3a1cf10` [\#2015](https://github.com/DEFRA/waste-exemptions-back-office/pull/2015) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rack from 2.2.21 to 2.2.22 [\#2007](https://github.com/DEFRA/waste-exemptions-back-office/pull/2007) ([dependabot[bot]](https://github.com/apps/dependabot))
- Replace require with load to avoid undefined method score error on fi… [\#2003](https://github.com/DEFRA/waste-exemptions-back-office/pull/2003) ([brujeo](https://github.com/brujeo))
- Refactor new registration handling to remove legacy code and simplify logic [\#1985](https://github.com/DEFRA/waste-exemptions-back-office/pull/1985) ([jjromeo](https://github.com/jjromeo))

## [v4.0.1](https://github.com/defra/waste-exemptions-back-office/tree/v4.0.1) (2026-02-02)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v4.0.0...v4.0.1)

**Implemented enhancements:**

- \[RUBY-4167\] Refactor eligible\_for\_free\_renewal? method and exclude t28 from free renewals [\#1991](https://github.com/DEFRA/waste-exemptions-back-office/pull/1991) ([brujeo](https://github.com/brujeo))

**Merged pull requests:**

- Move github\_changelog\_generator gem outside of development group [\#1998](https://github.com/DEFRA/waste-exemptions-back-office/pull/1998) ([brujeo](https://github.com/brujeo))
- Release/v4.0.1 [\#1997](https://github.com/DEFRA/waste-exemptions-back-office/pull/1997) ([brujeo](https://github.com/brujeo))
- Bump waste\_exemptions\_engine from `d80ceb2` to `46e16f4` [\#1996](https://github.com/DEFRA/waste-exemptions-back-office/pull/1996) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `a52f6d6` to `d80ceb2` [\#1994](https://github.com/DEFRA/waste-exemptions-back-office/pull/1994) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump devise from 4.9.4 to 5.0.0 [\#1990](https://github.com/DEFRA/waste-exemptions-back-office/pull/1990) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump whenever from 1.1.1 to 1.1.2 [\#1984](https://github.com/DEFRA/waste-exemptions-back-office/pull/1984) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump selenium-webdriver from 4.39.0 to 4.40.0 [\#1983](https://github.com/DEFRA/waste-exemptions-back-office/pull/1983) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump pry-byebug from 3.11.0 to 3.12.0 [\#1982](https://github.com/DEFRA/waste-exemptions-back-office/pull/1982) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v4.0.0](https://github.com/defra/waste-exemptions-back-office/tree/v4.0.0) (2026-01-23)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v3.2.0...v4.0.0)

**Implemented enhancements:**

- \[RUBY-4111\] Implement zero compliance cost band service and related tasks [\#1986](https://github.com/DEFRA/waste-exemptions-back-office/pull/1986) ([jjromeo](https://github.com/jjromeo))
- \[RUBY-4081\] Adjusting renewal reminders for linear registrations [\#1977](https://github.com/DEFRA/waste-exemptions-back-office/pull/1977) ([brujeo](https://github.com/brujeo))

**Fixed bugs:**

- Fix/ruby 4133 site expired [\#1981](https://github.com/DEFRA/waste-exemptions-back-office/pull/1981) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- \[RUBY-4114\] Refactor patch links to use button\_to instead of link\_to [\#1980](https://github.com/DEFRA/waste-exemptions-back-office/pull/1980) ([brujeo](https://github.com/brujeo))

**Merged pull requests:**

- Update CHANGELOG for v4.0.0 [\#1988](https://github.com/DEFRA/waste-exemptions-back-office/pull/1988) ([jjromeo](https://github.com/jjromeo))
- \[RUBY-4117\] Remove 'unsafe-eval' from script\_src in secure headers configuration [\#1975](https://github.com/DEFRA/waste-exemptions-back-office/pull/1975) ([jjromeo](https://github.com/jjromeo))

## [v3.2.0](https://github.com/defra/waste-exemptions-back-office/tree/v3.2.0) (2025-08-21)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v3.1.0...v3.2.0)

## [v3.1.0](https://github.com/defra/waste-exemptions-back-office/tree/v3.1.0) (2025-08-21)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v3.0.1.1...v3.1.0)

## [v3.0.1.1](https://github.com/defra/waste-exemptions-back-office/tree/v3.0.1.1) (2025-07-24)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v3.0.1...v3.0.1.1)

## [v3.0.1](https://github.com/defra/waste-exemptions-back-office/tree/v3.0.1) (2025-07-02)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v3.0.0...v3.0.1)

## [v3.0.0](https://github.com/defra/waste-exemptions-back-office/tree/v3.0.0) (2025-06-25)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.20.4...v3.0.0)

## [v2.20.4](https://github.com/defra/waste-exemptions-back-office/tree/v2.20.4) (2025-03-26)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.20.3...v2.20.4)

## [v2.20.3](https://github.com/defra/waste-exemptions-back-office/tree/v2.20.3) (2025-03-14)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.20.2...v2.20.3)

## [v2.20.2](https://github.com/defra/waste-exemptions-back-office/tree/v2.20.2) (2025-02-27)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.20.1...v2.20.2)

## [v2.20.1](https://github.com/defra/waste-exemptions-back-office/tree/v2.20.1) (2025-02-24)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.20.0...v2.20.1)

## [v2.20.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.20.0) (2025-02-17)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.19.0...v2.20.0)

## [v2.19.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.19.0) (2025-02-03)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.18.1...v2.19.0)

## [v2.18.1](https://github.com/defra/waste-exemptions-back-office/tree/v2.18.1) (2025-01-21)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.18.0...v2.18.1)

## [v2.18.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.18.0) (2025-01-14)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.17.0...v2.18.0)

## [v2.17.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.17.0) (2024-10-30)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.16.0...v2.17.0)

## [v2.16.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.16.0) (2024-09-16)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.15.0...v2.16.0)

## [v2.15.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.15.0) (2024-08-05)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.14.0...v2.15.0)

## [v2.14.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.14.0) (2024-07-18)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.13.1...v2.14.0)

## [v2.13.1](https://github.com/defra/waste-exemptions-back-office/tree/v2.13.1) (2024-06-10)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.13.0...v2.13.1)

## [v2.13.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.13.0) (2024-05-29)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.12.0...v2.13.0)

## [v2.12.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.12.0) (2024-04-29)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.11.0...v2.12.0)

## [v2.11.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.11.0) (2024-03-18)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.10.0...v2.11.0)

## [v2.10.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.10.0) (2024-02-07)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.9.1...v2.10.0)

## [v2.9.1](https://github.com/defra/waste-exemptions-back-office/tree/v2.9.1) (2023-12-07)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.9.0...v2.9.1)

## [v2.9.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.9.0) (2023-11-13)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.8.0...v2.9.0)

## [v2.8.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.8.0) (2023-10-09)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.7.4...v2.8.0)

## [v2.7.4](https://github.com/defra/waste-exemptions-back-office/tree/v2.7.4) (2023-07-12)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.7.3...v2.7.4)

## [v2.7.3](https://github.com/defra/waste-exemptions-back-office/tree/v2.7.3) (2023-05-26)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.7.2...v2.7.3)

## [v2.7.2](https://github.com/defra/waste-exemptions-back-office/tree/v2.7.2) (2023-05-16)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.7.1...v2.7.2)

## [v2.7.1](https://github.com/defra/waste-exemptions-back-office/tree/v2.7.1) (2023-03-15)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.7.0...v2.7.1)

## [v2.7.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.7.0) (2023-03-07)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.6.2...v2.7.0)

## [v2.6.2](https://github.com/defra/waste-exemptions-back-office/tree/v2.6.2) (2022-11-01)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.6.1...v2.6.2)

## [v2.6.1](https://github.com/defra/waste-exemptions-back-office/tree/v2.6.1) (2022-09-15)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.6.0...v2.6.1)

## [v2.6.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.6.0) (2022-08-10)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.5.1...v2.6.0)

## [v2.5.1](https://github.com/defra/waste-exemptions-back-office/tree/v2.5.1) (2022-05-12)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.5.0...v2.5.1)

## [v2.5.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.5.0) (2021-12-06)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.4.0...v2.5.0)

## [v2.4.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.4.0) (2021-05-20)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.3.0...v2.4.0)

## [v2.3.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.3.0) (2021-04-15)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.2.0...v2.3.0)

## [v2.2.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.2.0) (2021-03-15)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.1.0...v2.2.0)

## [v2.1.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.1.0) (2020-12-10)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.0.1...v2.1.0)

## [v2.0.1](https://github.com/defra/waste-exemptions-back-office/tree/v2.0.1) (2020-07-10)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.0.0...v2.0.1)

## [v2.0.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.0.0) (2020-06-23)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v1.3.1...v2.0.0)

## [v1.3.1](https://github.com/defra/waste-exemptions-back-office/tree/v1.3.1) (2020-02-13)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v1.3.0...v1.3.1)

## [v1.3.0](https://github.com/defra/waste-exemptions-back-office/tree/v1.3.0) (2019-10-22)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v1.2.1...v1.3.0)

## [v1.2.1](https://github.com/defra/waste-exemptions-back-office/tree/v1.2.1) (2019-09-10)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v1.2.0...v1.2.1)

## [v1.2.0](https://github.com/defra/waste-exemptions-back-office/tree/v1.2.0) (2019-09-06)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v1.1.1...v1.2.0)

## [v1.1.1](https://github.com/defra/waste-exemptions-back-office/tree/v1.1.1) (2019-08-20)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v1.1.0...v1.1.1)

## [v1.1.0](https://github.com/defra/waste-exemptions-back-office/tree/v1.1.0) (2019-08-15)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v1.0.2...v1.1.0)

**Implemented enhancements:**

- Update schema [\#311](https://github.com/DEFRA/waste-exemptions-back-office/pull/311) ([cintamani](https://github.com/cintamani))
- Add EA logo to renew email [\#308](https://github.com/DEFRA/waste-exemptions-back-office/pull/308) ([Cruikshanks](https://github.com/Cruikshanks))
- Use ENV variable to setup magic link feature toggle [\#306](https://github.com/DEFRA/waste-exemptions-back-office/pull/306) ([cintamani](https://github.com/cintamani))
- Update schema - Drop reference index on transient registrations [\#300](https://github.com/DEFRA/waste-exemptions-back-office/pull/300) ([cintamani](https://github.com/cintamani))
- Add schema changes [\#298](https://github.com/DEFRA/waste-exemptions-back-office/pull/298) ([cintamani](https://github.com/cintamani))
- Add configs for generating and decoding a renew JWT token [\#293](https://github.com/DEFRA/waste-exemptions-back-office/pull/293) ([cintamani](https://github.com/cintamani))
- Activate first email reminder feature [\#281](https://github.com/DEFRA/waste-exemptions-back-office/pull/281) ([cintamani](https://github.com/cintamani))

**Fixed bugs:**

- Close Airbrake to execute async promises [\#286](https://github.com/DEFRA/waste-exemptions-back-office/pull/286) ([cintamani](https://github.com/cintamani))

**Merged pull requests:**

- Bump waste\_exemptions\_engine from `405ea84` to `dea555c` [\#313](https://github.com/DEFRA/waste-exemptions-back-office/pull/313) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `c887823` to `405ea84` [\#312](https://github.com/DEFRA/waste-exemptions-back-office/pull/312) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `75ffb45` to `c887823` [\#310](https://github.com/DEFRA/waste-exemptions-back-office/pull/310) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `c7a6eeb` to `75ffb45` [\#309](https://github.com/DEFRA/waste-exemptions-back-office/pull/309) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `edfd070` to `c7a6eeb` [\#307](https://github.com/DEFRA/waste-exemptions-back-office/pull/307) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update token generation in renew email [\#305](https://github.com/DEFRA/waste-exemptions-back-office/pull/305) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `3aaf2ca` to `2fe17a0` [\#304](https://github.com/DEFRA/waste-exemptions-back-office/pull/304) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `8b70bb3` to `3aaf2ca` [\#303](https://github.com/DEFRA/waste-exemptions-back-office/pull/303) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Enable BOXI export job [\#302](https://github.com/DEFRA/waste-exemptions-back-office/pull/302) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `fa118f0` to `8b70bb3` [\#301](https://github.com/DEFRA/waste-exemptions-back-office/pull/301) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `ad29a5b` to `fa118f0` [\#299](https://github.com/DEFRA/waste-exemptions-back-office/pull/299) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump dotenv-rails from 2.7.4 to 2.7.5 [\#295](https://github.com/DEFRA/waste-exemptions-back-office/pull/295) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.6.0 to 3.6.2 [\#294](https://github.com/DEFRA/waste-exemptions-back-office/pull/294) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update .env.example post BOXI changes [\#292](https://github.com/DEFRA/waste-exemptions-back-office/pull/292) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `754e010` to `703f84c` [\#291](https://github.com/DEFRA/waste-exemptions-back-office/pull/291) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update renewal email to use magic link [\#290](https://github.com/DEFRA/waste-exemptions-back-office/pull/290) ([irisfaraway](https://github.com/irisfaraway))
- Move BOXI export to reports namespace [\#287](https://github.com/DEFRA/waste-exemptions-back-office/pull/287) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `4ed93c0` to `754e010` [\#285](https://github.com/DEFRA/waste-exemptions-back-office/pull/285) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.0.2](https://github.com/defra/waste-exemptions-back-office/tree/v1.0.2) (2019-07-26)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/hotfix/v1.0.1...v1.0.2)

**Implemented enhancements:**

- Add feature toggle on Boxi export [\#283](https://github.com/DEFRA/waste-exemptions-back-office/pull/283) ([cintamani](https://github.com/cintamani))
- Prevent exports to fail if a required address is missing [\#280](https://github.com/DEFRA/waste-exemptions-back-office/pull/280) ([cintamani](https://github.com/cintamani))
- Schedule boxi generation service job [\#277](https://github.com/DEFRA/waste-exemptions-back-office/pull/277) ([cintamani](https://github.com/cintamani))
- Generate Boxi report CSV files for AWS export [\#276](https://github.com/DEFRA/waste-exemptions-back-office/pull/276) ([cintamani](https://github.com/cintamani))

**Merged pull requests:**

- Bump waste\_exemptions\_engine from `d1b939d` to `4ed93c0` [\#284](https://github.com/DEFRA/waste-exemptions-back-office/pull/284) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `b2b3d37` to `d1b939d` [\#282](https://github.com/DEFRA/waste-exemptions-back-office/pull/282) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rubyzip from 1.2.2 to 1.2.3 [\#279](https://github.com/DEFRA/waste-exemptions-back-office/pull/279) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `bb44a8d` to `b2b3d37` [\#278](https://github.com/DEFRA/waste-exemptions-back-office/pull/278) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `7bdc763` to `bb44a8d` [\#275](https://github.com/DEFRA/waste-exemptions-back-office/pull/275) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [hotfix/v1.0.1](https://github.com/defra/waste-exemptions-back-office/tree/hotfix/v1.0.1) (2019-07-22)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v1.0.0...hotfix/v1.0.1)

## [v1.0.0](https://github.com/defra/waste-exemptions-back-office/tree/v1.0.0) (2019-07-10)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/8357bc375c784e3f00d5697005a12ac823f810b9...v1.0.0)

**Implemented enhancements:**

-  Attach logo to email instead of linking to gov.uk  [\#266](https://github.com/DEFRA/waste-exemptions-back-office/pull/266) ([cintamani](https://github.com/cintamani))
- Add privacy policy for Assited Digital [\#265](https://github.com/DEFRA/waste-exemptions-back-office/pull/265) ([cintamani](https://github.com/cintamani))
- Include polyfill for old browsers support [\#263](https://github.com/DEFRA/waste-exemptions-back-office/pull/263) ([cintamani](https://github.com/cintamani))
- Schedule the registration exemptions expiry job to run daily [\#256](https://github.com/DEFRA/waste-exemptions-back-office/pull/256) ([cintamani](https://github.com/cintamani))
- Add rake task to set the status of expired registration exemptions [\#255](https://github.com/DEFRA/waste-exemptions-back-office/pull/255) ([cintamani](https://github.com/cintamani))
- Add feature toggle check for first email reminder [\#254](https://github.com/DEFRA/waste-exemptions-back-office/pull/254) ([cintamani](https://github.com/cintamani))
- Schedule first email reminder job [\#245](https://github.com/DEFRA/waste-exemptions-back-office/pull/245) ([cintamani](https://github.com/cintamani))
- Update bulk exporter schedule to be daily [\#244](https://github.com/DEFRA/waste-exemptions-back-office/pull/244) ([Cruikshanks](https://github.com/Cruikshanks))
- Add rake task to send first email reminder for renewals [\#243](https://github.com/DEFRA/waste-exemptions-back-office/pull/243) ([cintamani](https://github.com/cintamani))
- Build first reminder email [\#229](https://github.com/DEFRA/waste-exemptions-back-office/pull/229) ([irisfaraway](https://github.com/irisfaraway))
- Implement EPR exports with new DefraRubyAws gem [\#222](https://github.com/DEFRA/waste-exemptions-back-office/pull/222) ([cintamani](https://github.com/cintamani))
-  Remove operator from address data bulk export [\#220](https://github.com/DEFRA/waste-exemptions-back-office/pull/220) ([cintamani](https://github.com/cintamani))
- Change return field for assisted mode [\#219](https://github.com/DEFRA/waste-exemptions-back-office/pull/219) ([cintamani](https://github.com/cintamani))
- Remove change your password link from the back office dashboard [\#212](https://github.com/DEFRA/waste-exemptions-back-office/pull/212) ([cintamani](https://github.com/cintamani))
- Use the new Reports::GeneratedReport to deal with reports permissions [\#209](https://github.com/DEFRA/waste-exemptions-back-office/pull/209) ([cintamani](https://github.com/cintamani))
- Update schedule to run the new export rake task [\#208](https://github.com/DEFRA/waste-exemptions-back-office/pull/208) ([cintamani](https://github.com/cintamani))
- Set correct TZ timezone [\#204](https://github.com/DEFRA/waste-exemptions-back-office/pull/204) ([cintamani](https://github.com/cintamani))
- Add links to AWS bulk export files [\#203](https://github.com/DEFRA/waste-exemptions-back-office/pull/203) ([cintamani](https://github.com/cintamani))
- Monthly Bulk Export - Ensure the database entries are cleared [\#201](https://github.com/DEFRA/waste-exemptions-back-office/pull/201) ([cintamani](https://github.com/cintamani))
- Save report generation to the database [\#199](https://github.com/DEFRA/waste-exemptions-back-office/pull/199) ([cintamani](https://github.com/cintamani))
- Implement Aws bucket load of report bulk CSV files [\#198](https://github.com/DEFRA/waste-exemptions-back-office/pull/198) ([cintamani](https://github.com/cintamani))
- Update to include site address area [\#194](https://github.com/DEFRA/waste-exemptions-back-office/pull/194) ([Cruikshanks](https://github.com/Cruikshanks))
- Exemptions Bulk export rake task  [\#191](https://github.com/DEFRA/waste-exemptions-back-office/pull/191) ([cintamani](https://github.com/cintamani))
- Add operator details in the registration view and change label [\#176](https://github.com/DEFRA/waste-exemptions-back-office/pull/176) ([cintamani](https://github.com/cintamani))
- Configure editing permissions [\#153](https://github.com/DEFRA/waste-exemptions-back-office/pull/153) ([irisfaraway](https://github.com/irisfaraway))
- Set up edit links in back office [\#142](https://github.com/DEFRA/waste-exemptions-back-office/pull/142) ([irisfaraway](https://github.com/irisfaraway))
- Expose confirmation letter [\#130](https://github.com/DEFRA/waste-exemptions-back-office/pull/130) ([eminnett](https://github.com/eminnett))
- Update to support last email cache feature [\#120](https://github.com/DEFRA/waste-exemptions-back-office/pull/120) ([Cruikshanks](https://github.com/Cruikshanks))
- Add ability to deregister a whole registration [\#119](https://github.com/DEFRA/waste-exemptions-back-office/pull/119) ([eminnett](https://github.com/eminnett))
- Add bulk export functionality to DefraRuby::Exporters [\#105](https://github.com/DEFRA/waste-exemptions-back-office/pull/105) ([eminnett](https://github.com/eminnett))
- Set default assistance\_mode [\#92](https://github.com/DEFRA/waste-exemptions-back-office/pull/92) ([irisfaraway](https://github.com/irisfaraway))
- Support individual exemption deregistration [\#90](https://github.com/DEFRA/waste-exemptions-back-office/pull/90) ([eminnett](https://github.com/eminnett))
- Allow back office users to complete an in-progress registration [\#85](https://github.com/DEFRA/waste-exemptions-back-office/pull/85) ([irisfaraway](https://github.com/irisfaraway))
- Implement PaperTrail for auditing [\#75](https://github.com/DEFRA/waste-exemptions-back-office/pull/75) ([irisfaraway](https://github.com/irisfaraway))
- Create public register exporter [\#69](https://github.com/DEFRA/waste-exemptions-back-office/pull/69) ([eminnett](https://github.com/eminnett))
- Search for in-progress new registrations [\#62](https://github.com/DEFRA/waste-exemptions-back-office/pull/62) ([irisfaraway](https://github.com/irisfaraway))
- Add registration details page [\#56](https://github.com/DEFRA/waste-exemptions-back-office/pull/56) ([irisfaraway](https://github.com/irisfaraway))
- Link to start a new AD registration [\#55](https://github.com/DEFRA/waste-exemptions-back-office/pull/55) ([irisfaraway](https://github.com/irisfaraway))
- Change a user's role [\#52](https://github.com/DEFRA/waste-exemptions-back-office/pull/52) ([irisfaraway](https://github.com/irisfaraway))
- Force ssl in production environments [\#45](https://github.com/DEFRA/waste-exemptions-back-office/pull/45) ([Cruikshanks](https://github.com/Cruikshanks))
- Make use of airbrake configurable in initializer [\#38](https://github.com/DEFRA/waste-exemptions-back-office/pull/38) ([Cruikshanks](https://github.com/Cruikshanks))
- Add sign-out link to deactivated page [\#35](https://github.com/DEFRA/waste-exemptions-back-office/pull/35) ([irisfaraway](https://github.com/irisfaraway))
- Invite a new user to the back office [\#33](https://github.com/DEFRA/waste-exemptions-back-office/pull/33) ([irisfaraway](https://github.com/irisfaraway))
- Configure Sendgrid and add rake task to test emails [\#30](https://github.com/DEFRA/waste-exemptions-back-office/pull/30) ([irisfaraway](https://github.com/irisfaraway))
- Activate and deactivate back office user accounts [\#21](https://github.com/DEFRA/waste-exemptions-back-office/pull/21) ([irisfaraway](https://github.com/irisfaraway))
- Add dashboard for user management [\#19](https://github.com/DEFRA/waste-exemptions-back-office/pull/19) ([irisfaraway](https://github.com/irisfaraway))
- Display regs on dashboard in a useful way [\#16](https://github.com/DEFRA/waste-exemptions-back-office/pull/16) ([irisfaraway](https://github.com/irisfaraway))
- Add registration search to dashboard [\#9](https://github.com/DEFRA/waste-exemptions-back-office/pull/9) ([irisfaraway](https://github.com/irisfaraway))
- Add specific permissions to roles [\#8](https://github.com/DEFRA/waste-exemptions-back-office/pull/8) ([irisfaraway](https://github.com/irisfaraway))
- Add customised views for Devise pages [\#7](https://github.com/DEFRA/waste-exemptions-back-office/pull/7) ([irisfaraway](https://github.com/irisfaraway))
- Add roles to back office users [\#5](https://github.com/DEFRA/waste-exemptions-back-office/pull/5) ([irisfaraway](https://github.com/irisfaraway))
- Add users to back office [\#3](https://github.com/DEFRA/waste-exemptions-back-office/pull/3) ([irisfaraway](https://github.com/irisfaraway))
-  Add empty dashboard [\#2](https://github.com/DEFRA/waste-exemptions-back-office/pull/2) ([irisfaraway](https://github.com/irisfaraway))

**Fixed bugs:**

- Use id instead of reference to find the correct new registration [\#274](https://github.com/DEFRA/waste-exemptions-back-office/pull/274) ([cintamani](https://github.com/cintamani))
- Update privacy policy [\#270](https://github.com/DEFRA/waste-exemptions-back-office/pull/270) ([Cruikshanks](https://github.com/Cruikshanks))
- Fix minor bugs in first email reminder [\#260](https://github.com/DEFRA/waste-exemptions-back-office/pull/260) ([irisfaraway](https://github.com/irisfaraway))
- Break long emails onto multiple lines instead of overflowing [\#258](https://github.com/DEFRA/waste-exemptions-back-office/pull/258) ([irisfaraway](https://github.com/irisfaraway))
- Update schema.rb [\#253](https://github.com/DEFRA/waste-exemptions-back-office/pull/253) ([Cruikshanks](https://github.com/Cruikshanks))
- Fix bug on first day of the month bulk report generation [\#251](https://github.com/DEFRA/waste-exemptions-back-office/pull/251) ([cintamani](https://github.com/cintamani))
- Fix error when in confirmation letter for expired [\#248](https://github.com/DEFRA/waste-exemptions-back-office/pull/248) ([Cruikshanks](https://github.com/Cruikshanks))
- Add missing mailto to link [\#247](https://github.com/DEFRA/waste-exemptions-back-office/pull/247) ([cintamani](https://github.com/cintamani))
- Make sure Registration states are returned in order of importance [\#242](https://github.com/DEFRA/waste-exemptions-back-office/pull/242) ([cintamani](https://github.com/cintamani))
- Fix HTML W3C issues [\#241](https://github.com/DEFRA/waste-exemptions-back-office/pull/241) ([cintamani](https://github.com/cintamani))
- Use registration state when displaying registrations in the dashboard [\#239](https://github.com/DEFRA/waste-exemptions-back-office/pull/239) ([cintamani](https://github.com/cintamani))
- Require `csv` library in reports base serializer [\#234](https://github.com/DEFRA/waste-exemptions-back-office/pull/234) ([cintamani](https://github.com/cintamani))
- Downgrade Postgres version to 9.6 [\#218](https://github.com/DEFRA/waste-exemptions-back-office/pull/218) ([cintamani](https://github.com/cintamani))
- Return blank site address when location is by grid reference [\#213](https://github.com/DEFRA/waste-exemptions-back-office/pull/213) ([cintamani](https://github.com/cintamani))
- Fix WEX data exports [\#189](https://github.com/DEFRA/waste-exemptions-back-office/pull/189) ([cintamani](https://github.com/cintamani))
- Save session token change to database [\#188](https://github.com/DEFRA/waste-exemptions-back-office/pull/188) ([irisfaraway](https://github.com/irisfaraway))
- Fix test fail when run at midnight BST [\#185](https://github.com/DEFRA/waste-exemptions-back-office/pull/185) ([Cruikshanks](https://github.com/Cruikshanks))
- Remove wickedpdf gem and configs [\#182](https://github.com/DEFRA/waste-exemptions-back-office/pull/182) ([cintamani](https://github.com/cintamani))
- Require defra-ruby-exporters gem before Rails tasks are loaded [\#172](https://github.com/DEFRA/waste-exemptions-back-office/pull/172) ([cintamani](https://github.com/cintamani))
- Set the config timezone to be London rather than UTC [\#166](https://github.com/DEFRA/waste-exemptions-back-office/pull/166) ([cintamani](https://github.com/cintamani))
- Refactor the code to use the service checker permission [\#163](https://github.com/DEFRA/waste-exemptions-back-office/pull/163) ([cintamani](https://github.com/cintamani))
- Fix bug on show of New registration objects [\#159](https://github.com/DEFRA/waste-exemptions-back-office/pull/159) ([cintamani](https://github.com/cintamani))
- Inherit SCSS from engine [\#152](https://github.com/DEFRA/waste-exemptions-back-office/pull/152) ([irisfaraway](https://github.com/irisfaraway))
- Fix EditHelper inheritance and overriding [\#151](https://github.com/DEFRA/waste-exemptions-back-office/pull/151) ([irisfaraway](https://github.com/irisfaraway))
- Add test coverage for correct handling of 404 errors. [\#147](https://github.com/DEFRA/waste-exemptions-back-office/pull/147) ([cintamani](https://github.com/cintamani))
- Fix issues found with confirmation letter [\#135](https://github.com/DEFRA/waste-exemptions-back-office/pull/135) ([Cruikshanks](https://github.com/Cruikshanks))
- Fix :month\_year date formatting [\#124](https://github.com/DEFRA/waste-exemptions-back-office/pull/124) ([eminnett](https://github.com/eminnett))
- Fix data exports accessibility issues [\#122](https://github.com/DEFRA/waste-exemptions-back-office/pull/122) ([eminnett](https://github.com/eminnett))
- Fix 'load constant' and other 500 errors [\#118](https://github.com/DEFRA/waste-exemptions-back-office/pull/118) ([eminnett](https://github.com/eminnett))
- Refactor the whenever schedule to use Rake [\#104](https://github.com/DEFRA/waste-exemptions-back-office/pull/104) ([eminnett](https://github.com/eminnett))
- Fix Airbrake for the dev environment [\#100](https://github.com/DEFRA/waste-exemptions-back-office/pull/100) ([eminnett](https://github.com/eminnett))
- Make whenever cron log output configurable [\#99](https://github.com/DEFRA/waste-exemptions-back-office/pull/99) ([Cruikshanks](https://github.com/Cruikshanks))
- Fix error when calling `bundle exec whenever` [\#98](https://github.com/DEFRA/waste-exemptions-back-office/pull/98) ([eminnett](https://github.com/eminnett))
- Remove extra version migration [\#91](https://github.com/DEFRA/waste-exemptions-back-office/pull/91) ([irisfaraway](https://github.com/irisfaraway))
- Display dates in human-friendly format [\#84](https://github.com/DEFRA/waste-exemptions-back-office/pull/84) ([irisfaraway](https://github.com/irisfaraway))
- Remove site address from results if not yet added [\#74](https://github.com/DEFRA/waste-exemptions-back-office/pull/74) ([irisfaraway](https://github.com/irisfaraway))
- Add fieldset for search filters [\#72](https://github.com/DEFRA/waste-exemptions-back-office/pull/72) ([irisfaraway](https://github.com/irisfaraway))
- Deal with excess whitespace when searching [\#71](https://github.com/DEFRA/waste-exemptions-back-office/pull/71) ([irisfaraway](https://github.com/irisfaraway))
- Remove 'change AD level' link from search results [\#70](https://github.com/DEFRA/waste-exemptions-back-office/pull/70) ([irisfaraway](https://github.com/irisfaraway))
- Block data agents from doing AD registrations [\#61](https://github.com/DEFRA/waste-exemptions-back-office/pull/61) ([irisfaraway](https://github.com/irisfaraway))
- Fix people form button styling [\#60](https://github.com/DEFRA/waste-exemptions-back-office/pull/60) ([irisfaraway](https://github.com/irisfaraway))
- Set secret\_key\_base when run under prod & rake [\#39](https://github.com/DEFRA/waste-exemptions-back-office/pull/39) ([Cruikshanks](https://github.com/Cruikshanks))
- Display partner names on separate lines [\#26](https://github.com/DEFRA/waste-exemptions-back-office/pull/26) ([irisfaraway](https://github.com/irisfaraway))
- Display pagination on registration dashboard [\#25](https://github.com/DEFRA/waste-exemptions-back-office/pull/25) ([irisfaraway](https://github.com/irisfaraway))
- Fix missing and inaccurate Devise text [\#15](https://github.com/DEFRA/waste-exemptions-back-office/pull/15) ([irisfaraway](https://github.com/irisfaraway))

**Security fixes:**

- \[Security\] Bump nokogiri from 1.10.2 to 1.10.3 [\#138](https://github.com/DEFRA/waste-exemptions-back-office/pull/138) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- \[Security\] Bump rails from 4.2.11 to 4.2.11.1 [\#81](https://github.com/DEFRA/waste-exemptions-back-office/pull/81) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

**Merged pull requests:**

- Bump waste\_exemptions\_engine from `7a60ed5` to `7bdc763` [\#273](https://github.com/DEFRA/waste-exemptions-back-office/pull/273) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Use id instead of reference when dealing with in progress registrations [\#272](https://github.com/DEFRA/waste-exemptions-back-office/pull/272) ([cintamani](https://github.com/cintamani))
- Bump waste\_exemptions\_engine from `dd899ab` to `9c8a81e` [\#269](https://github.com/DEFRA/waste-exemptions-back-office/pull/269) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `7ee85c2` to `dd899ab` [\#268](https://github.com/DEFRA/waste-exemptions-back-office/pull/268) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `7249eff` to `7ee85c2` [\#267](https://github.com/DEFRA/waste-exemptions-back-office/pull/267) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `165b121` to `7249eff` [\#264](https://github.com/DEFRA/waste-exemptions-back-office/pull/264) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `78aca60` to `165b121` [\#262](https://github.com/DEFRA/waste-exemptions-back-office/pull/262) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `78aca60` to `599b71a` [\#261](https://github.com/DEFRA/waste-exemptions-back-office/pull/261) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `2159567` to `78aca60` [\#259](https://github.com/DEFRA/waste-exemptions-back-office/pull/259) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump simplecov from 0.16.1 to 0.17.0 [\#257](https://github.com/DEFRA/waste-exemptions-back-office/pull/257) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Do not seed exemptions in the test suite, use factories instead [\#252](https://github.com/DEFRA/waste-exemptions-back-office/pull/252) ([cintamani](https://github.com/cintamani))
- Bump waste\_exemptions\_engine from `cb44d5e` to `472036c` [\#250](https://github.com/DEFRA/waste-exemptions-back-office/pull/250) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Rename email reminders task to include `first` [\#246](https://github.com/DEFRA/waste-exemptions-back-office/pull/246) ([cintamani](https://github.com/cintamani))
- Bump waste\_exemptions\_engine from `aebb0e3` to `cb44d5e` [\#240](https://github.com/DEFRA/waste-exemptions-back-office/pull/240) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `19f394d` to `aebb0e3` [\#238](https://github.com/DEFRA/waste-exemptions-back-office/pull/238) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Fix defra\_ruby\_aws gem name [\#235](https://github.com/DEFRA/waste-exemptions-back-office/pull/235) ([irisfaraway](https://github.com/irisfaraway))
- Bump dotenv-rails from 2.7.2 to 2.7.4 [\#233](https://github.com/DEFRA/waste-exemptions-back-office/pull/233) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `6d0dd8b` to `19f394d` [\#231](https://github.com/DEFRA/waste-exemptions-back-office/pull/231) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `6fe99c3` to `6d0dd8b` [\#228](https://github.com/DEFRA/waste-exemptions-back-office/pull/228) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `f7de1ee` to `6fe99c3` [\#226](https://github.com/DEFRA/waste-exemptions-back-office/pull/226) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump spring from 2.0.2 to 2.1.0 [\#225](https://github.com/DEFRA/waste-exemptions-back-office/pull/225) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Remove defra\_ruby\_exporters gem and its configuration [\#224](https://github.com/DEFRA/waste-exemptions-back-office/pull/224) ([cintamani](https://github.com/cintamani))
- Remove VCR and its configuration [\#223](https://github.com/DEFRA/waste-exemptions-back-office/pull/223) ([cintamani](https://github.com/cintamani))
- Bump jquery-rails from 4.3.3 to 4.3.5 [\#221](https://github.com/DEFRA/waste-exemptions-back-office/pull/221) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra-ruby-aws from `25a3d5e` to `0c25a93` [\#215](https://github.com/DEFRA/waste-exemptions-back-office/pull/215) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Use application configs to access ENV variables [\#210](https://github.com/DEFRA/waste-exemptions-back-office/pull/210) ([cintamani](https://github.com/cintamani))
- Update reports namespace to be consistent [\#207](https://github.com/DEFRA/waste-exemptions-back-office/pull/207) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `de9187c` to `f7de1ee` [\#206](https://github.com/DEFRA/waste-exemptions-back-office/pull/206) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Rename the reports table and add data dates info [\#205](https://github.com/DEFRA/waste-exemptions-back-office/pull/205) ([cintamani](https://github.com/cintamani))
- Bump defra-ruby-aws from `9cee098` to `25a3d5e` [\#202](https://github.com/DEFRA/waste-exemptions-back-office/pull/202) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra-ruby-aws from `dde4342` to `9cee098` [\#200](https://github.com/DEFRA/waste-exemptions-back-office/pull/200) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `e3f715f` to `de9187c` [\#197](https://github.com/DEFRA/waste-exemptions-back-office/pull/197) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_style from 0.1.1 to 0.1.2 [\#196](https://github.com/DEFRA/waste-exemptions-back-office/pull/196) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.5.1 to 3.6.0 [\#195](https://github.com/DEFRA/waste-exemptions-back-office/pull/195) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `50e6e5c` to `e3f715f` [\#193](https://github.com/DEFRA/waste-exemptions-back-office/pull/193) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `d1c0898` to `50e6e5c` [\#190](https://github.com/DEFRA/waste-exemptions-back-office/pull/190) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `94e0dc1` to `d1c0898` [\#187](https://github.com/DEFRA/waste-exemptions-back-office/pull/187) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `3aec520` to `94e0dc1` [\#186](https://github.com/DEFRA/waste-exemptions-back-office/pull/186) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Rename deregistered\_on to deregistered\_at [\#180](https://github.com/DEFRA/waste-exemptions-back-office/pull/180) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `c904786` to `c5d8bc7` [\#179](https://github.com/DEFRA/waste-exemptions-back-office/pull/179) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `eb59af4` to `c904786` [\#178](https://github.com/DEFRA/waste-exemptions-back-office/pull/178) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_exporters from `95a2bd7` to `3ef183e` [\#177](https://github.com/DEFRA/waste-exemptions-back-office/pull/177) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump wicked\_pdf from 1.2.2 to 1.3.0 [\#175](https://github.com/DEFRA/waste-exemptions-back-office/pull/175) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_exporters from `fa29156` to `95a2bd7` [\#174](https://github.com/DEFRA/waste-exemptions-back-office/pull/174) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `035a144` to `eb59af4` [\#173](https://github.com/DEFRA/waste-exemptions-back-office/pull/173) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `f80a8c4` to `035a144` [\#171](https://github.com/DEFRA/waste-exemptions-back-office/pull/171) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `20cd718` to `f80a8c4` [\#169](https://github.com/DEFRA/waste-exemptions-back-office/pull/169) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `d35328e` to `20cd718` [\#168](https://github.com/DEFRA/waste-exemptions-back-office/pull/168) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `98b47b1` to `d35328e` [\#167](https://github.com/DEFRA/waste-exemptions-back-office/pull/167) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `24cb548` to `98b47b1` [\#165](https://github.com/DEFRA/waste-exemptions-back-office/pull/165) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `2f7d262` to `451e48f` [\#161](https://github.com/DEFRA/waste-exemptions-back-office/pull/161) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `160b805` to `2f7d262` [\#157](https://github.com/DEFRA/waste-exemptions-back-office/pull/157) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Revert "Add test coverage for correct handling of 404 errors." [\#155](https://github.com/DEFRA/waste-exemptions-back-office/pull/155) ([cintamani](https://github.com/cintamani))
- Bump waste\_exemptions\_engine from `6c151d2` to `160b805` [\#150](https://github.com/DEFRA/waste-exemptions-back-office/pull/150) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update README.md [\#149](https://github.com/DEFRA/waste-exemptions-back-office/pull/149) ([cintamani](https://github.com/cintamani))
- Remove byebug and swap it with pry-byebug [\#148](https://github.com/DEFRA/waste-exemptions-back-office/pull/148) ([cintamani](https://github.com/cintamani))
- Bump waste\_exemptions\_engine from `409705b` to `110dca6` [\#146](https://github.com/DEFRA/waste-exemptions-back-office/pull/146) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `409705b` to `38f3e3f` [\#145](https://github.com/DEFRA/waste-exemptions-back-office/pull/145) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `54d2deb` to `409705b` [\#144](https://github.com/DEFRA/waste-exemptions-back-office/pull/144) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `937b673` to `54d2deb` [\#143](https://github.com/DEFRA/waste-exemptions-back-office/pull/143) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Use NewRegistration instead of TransientRegistration when appropriate [\#141](https://github.com/DEFRA/waste-exemptions-back-office/pull/141) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_exemptions\_engine from `f2b437a` to `937b673` [\#140](https://github.com/DEFRA/waste-exemptions-back-office/pull/140) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `d217c79` to `f2b437a` [\#139](https://github.com/DEFRA/waste-exemptions-back-office/pull/139) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `dc1d588` to `d217c79` [\#134](https://github.com/DEFRA/waste-exemptions-back-office/pull/134) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump factory\_bot\_rails from 5.0.1 to 5.0.2 [\#133](https://github.com/DEFRA/waste-exemptions-back-office/pull/133) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `bebec17` to `dc1d588` [\#132](https://github.com/DEFRA/waste-exemptions-back-office/pull/132) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `4a6ce24` to `bebec17` [\#131](https://github.com/DEFRA/waste-exemptions-back-office/pull/131) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Integrate exporters gem [\#129](https://github.com/DEFRA/waste-exemptions-back-office/pull/129) ([eminnett](https://github.com/eminnett))
- Bump waste\_exemptions\_engine from `240c532` to `4a6ce24` [\#128](https://github.com/DEFRA/waste-exemptions-back-office/pull/128) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Fix status-tag css colour conflict [\#127](https://github.com/DEFRA/waste-exemptions-back-office/pull/127) ([eminnett](https://github.com/eminnett))
- Fix individual de-registration bugs [\#126](https://github.com/DEFRA/waste-exemptions-back-office/pull/126) ([eminnett](https://github.com/eminnett))
- Bump waste\_exemptions\_engine from `1786e24` to `240c532` [\#125](https://github.com/DEFRA/waste-exemptions-back-office/pull/125) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `e2666ba` to `1786e24` [\#123](https://github.com/DEFRA/waste-exemptions-back-office/pull/123) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_style from 0.1.0 to 0.1.1 [\#121](https://github.com/DEFRA/waste-exemptions-back-office/pull/121) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Attempt to fix intermittent failures on Travis [\#117](https://github.com/DEFRA/waste-exemptions-back-office/pull/117) ([eminnett](https://github.com/eminnett))
- Add Bullet and fix unoptimised queries [\#116](https://github.com/DEFRA/waste-exemptions-back-office/pull/116) ([eminnett](https://github.com/eminnett))
- Bump aws-sdk-s3 from 1.35.0 to 1.36.0 [\#115](https://github.com/DEFRA/waste-exemptions-back-office/pull/115) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `a0d6c1a` to `81d68d8` [\#114](https://github.com/DEFRA/waste-exemptions-back-office/pull/114) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update schema to include deregistered\_on [\#113](https://github.com/DEFRA/waste-exemptions-back-office/pull/113) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump devise from 4.6.1 to 4.6.2 [\#112](https://github.com/DEFRA/waste-exemptions-back-office/pull/112) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `28a7a8b` to `a0d6c1a` [\#111](https://github.com/DEFRA/waste-exemptions-back-office/pull/111) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump dotenv-rails from 2.7.1 to 2.7.2 [\#110](https://github.com/DEFRA/waste-exemptions-back-office/pull/110) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Refactor the model concerns namespace  [\#109](https://github.com/DEFRA/waste-exemptions-back-office/pull/109) ([eminnett](https://github.com/eminnett))
- Bump waste\_exemptions\_engine from `10598a1` to `28a7a8b` [\#107](https://github.com/DEFRA/waste-exemptions-back-office/pull/107) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump aws-sdk-s3 from 1.34.0 to 1.35.0 [\#106](https://github.com/DEFRA/waste-exemptions-back-office/pull/106) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Add http-2 as a dependency [\#103](https://github.com/DEFRA/waste-exemptions-back-office/pull/103) ([eminnett](https://github.com/eminnett))
- Bump waste\_exemptions\_engine from `7b7db4f` to `10598a1` [\#102](https://github.com/DEFRA/waste-exemptions-back-office/pull/102) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump aws-sdk-s3 from 1.33.0 to 1.34.0 [\#101](https://github.com/DEFRA/waste-exemptions-back-office/pull/101) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `71278fc` to `7b7db4f` [\#97](https://github.com/DEFRA/waste-exemptions-back-office/pull/97) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump aws-sdk-s3 from 1.31.0 to 1.33.0 [\#96](https://github.com/DEFRA/waste-exemptions-back-office/pull/96) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump byebug from 11.0.0 to 11.0.1 [\#95](https://github.com/DEFRA/waste-exemptions-back-office/pull/95) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_style from 0.0.3 to 0.1.0 [\#94](https://github.com/DEFRA/waste-exemptions-back-office/pull/94) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `f841b5b` to `71278fc` [\#93](https://github.com/DEFRA/waste-exemptions-back-office/pull/93) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump paper\_trail from 10.2.0 to 10.2.1 [\#87](https://github.com/DEFRA/waste-exemptions-back-office/pull/87) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- a11y changes to exemption tag colour and table layout [\#83](https://github.com/DEFRA/waste-exemptions-back-office/pull/83) ([liammcmurray](https://github.com/liammcmurray))
- Bump waste\_exemptions\_engine from `efc228f` to `12ca417` [\#82](https://github.com/DEFRA/waste-exemptions-back-office/pull/82) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `61cd427` to `efc228f` [\#80](https://github.com/DEFRA/waste-exemptions-back-office/pull/80) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Unlock Rails version [\#79](https://github.com/DEFRA/waste-exemptions-back-office/pull/79) ([irisfaraway](https://github.com/irisfaraway))
- Add a root div to results in dashboard [\#78](https://github.com/DEFRA/waste-exemptions-back-office/pull/78) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `64b6b36` to `61cd427` [\#77](https://github.com/DEFRA/waste-exemptions-back-office/pull/77) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `9e5c4f0` to `64b6b36` [\#76](https://github.com/DEFRA/waste-exemptions-back-office/pull/76) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `e2b3976` to `9e5c4f0` [\#73](https://github.com/DEFRA/waste-exemptions-back-office/pull/73) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump govuk\_template from 0.25.0 to 0.26.0 [\#68](https://github.com/DEFRA/waste-exemptions-back-office/pull/68) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `05e08e1` to `e2b3976` [\#67](https://github.com/DEFRA/waste-exemptions-back-office/pull/67) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `c35b51b` to `05e08e1` [\#66](https://github.com/DEFRA/waste-exemptions-back-office/pull/66) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `650fd95` to `c35b51b` [\#65](https://github.com/DEFRA/waste-exemptions-back-office/pull/65) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_style from 0.0.2 to 0.0.3 [\#64](https://github.com/DEFRA/waste-exemptions-back-office/pull/64) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `735a03f` to `650fd95` [\#63](https://github.com/DEFRA/waste-exemptions-back-office/pull/63) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `8c46335` to `735a03f` [\#59](https://github.com/DEFRA/waste-exemptions-back-office/pull/59) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump dotenv-rails from 2.7.0 to 2.7.1 [\#58](https://github.com/DEFRA/waste-exemptions-back-office/pull/58) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `cd1fe98` to `8c46335` [\#54](https://github.com/DEFRA/waste-exemptions-back-office/pull/54) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump dotenv-rails from 2.6.0 to 2.7.0 [\#53](https://github.com/DEFRA/waste-exemptions-back-office/pull/53) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `8d02b2a` to `cd1fe98` [\#51](https://github.com/DEFRA/waste-exemptions-back-office/pull/51) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `c7b7cbb` to `8d02b2a` [\#50](https://github.com/DEFRA/waste-exemptions-back-office/pull/50) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `6772516` to `c7b7cbb` [\#49](https://github.com/DEFRA/waste-exemptions-back-office/pull/49) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Remove dummy secret key logic in application.rb [\#48](https://github.com/DEFRA/waste-exemptions-back-office/pull/48) ([Cruikshanks](https://github.com/Cruikshanks))
- Add pgreset gem to solve database in use errors [\#47](https://github.com/DEFRA/waste-exemptions-back-office/pull/47) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `eb356de` to `6772516` [\#46](https://github.com/DEFRA/waste-exemptions-back-office/pull/46) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update TravisCI badge URL [\#44](https://github.com/DEFRA/waste-exemptions-back-office/pull/44) ([irisfaraway](https://github.com/irisfaraway))
- Update farmer field names in DB [\#43](https://github.com/DEFRA/waste-exemptions-back-office/pull/43) ([irisfaraway](https://github.com/irisfaraway))
- Bump byebug from 10.0.2 to 11.0.0 [\#42](https://github.com/DEFRA/waste-exemptions-back-office/pull/42) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `39c46a9` to `eb356de` [\#41](https://github.com/DEFRA/waste-exemptions-back-office/pull/41) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `0e9f56a` to `39c46a9` [\#40](https://github.com/DEFRA/waste-exemptions-back-office/pull/40) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `1856398` to `0e9f56a` [\#37](https://github.com/DEFRA/waste-exemptions-back-office/pull/37) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `568bfa0` to `1856398` [\#36](https://github.com/DEFRA/waste-exemptions-back-office/pull/36) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `185c48d` to `568bfa0` [\#34](https://github.com/DEFRA/waste-exemptions-back-office/pull/34) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `ba77d7b` to `185c48d` [\#32](https://github.com/DEFRA/waste-exemptions-back-office/pull/32) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump devise from 4.6.0 to 4.6.1 [\#31](https://github.com/DEFRA/waste-exemptions-back-office/pull/31) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump factory\_bot\_rails from 5.0.0 to 5.0.1 [\#29](https://github.com/DEFRA/waste-exemptions-back-office/pull/29) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump devise from 4.5.0 to 4.6.0 [\#28](https://github.com/DEFRA/waste-exemptions-back-office/pull/28) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Add unique IDs to action links on dashboard [\#27](https://github.com/DEFRA/waste-exemptions-back-office/pull/27) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_exemptions\_engine from `232fb67` to `ba77d7b` [\#24](https://github.com/DEFRA/waste-exemptions-back-office/pull/24) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Align rspec test setup with WEX engine [\#23](https://github.com/DEFRA/waste-exemptions-back-office/pull/23) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `e1c5f25` to `232fb67` [\#22](https://github.com/DEFRA/waste-exemptions-back-office/pull/22) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `37fb7f5` to `e1c5f25` [\#20](https://github.com/DEFRA/waste-exemptions-back-office/pull/20) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump factory\_bot\_rails from 4.11.1 to 5.0.0 [\#18](https://github.com/DEFRA/waste-exemptions-back-office/pull/18) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `db51f8c` to `88cbe0c` [\#14](https://github.com/DEFRA/waste-exemptions-back-office/pull/14) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rspec-rails from 3.8.1 to 3.8.2 [\#12](https://github.com/DEFRA/waste-exemptions-back-office/pull/12) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump cancancan from 2.1.2 to 2.3.0 [\#11](https://github.com/DEFRA/waste-exemptions-back-office/pull/11) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Seed users to database [\#6](https://github.com/DEFRA/waste-exemptions-back-office/pull/6) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_exemptions\_engine from `3351b27` to `db51f8c` [\#4](https://github.com/DEFRA/waste-exemptions-back-office/pull/4) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Set up our standard CI [\#1](https://github.com/DEFRA/waste-exemptions-back-office/pull/1) ([irisfaraway](https://github.com/irisfaraway))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
