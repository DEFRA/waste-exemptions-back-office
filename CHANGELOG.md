# Changelog

## [v3.0.0](https://github.com/defra/waste-exemptions-back-office/tree/v3.0.0) (2025-06-25)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.20.4...v3.0.0)

**Implemented enhancements:**

- Chore/govpay mocks setup [\#1819](https://github.com/DEFRA/waste-exemptions-back-office/pull/1819) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Feature/ruby 3820 wex add deactivation of back office users based upon last log in time to cron job [\#1808](https://github.com/DEFRA/waste-exemptions-back-office/pull/1808) ([brujeo](https://github.com/brujeo))
- Add GovPay signature Rake task and corresponding tests [\#1807](https://github.com/DEFRA/waste-exemptions-back-office/pull/1807) ([brujeo](https://github.com/brujeo))
- Feature/ruby 3772 wex charging record exemption expiry date extension reason in change history [\#1792](https://github.com/DEFRA/waste-exemptions-back-office/pull/1792) ([brujeo](https://github.com/brujeo))
- Add defra\_ruby\_mocks [\#1783](https://github.com/DEFRA/waste-exemptions-back-office/pull/1783) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Feature/ruby 3744 hide initial versions from change history page [\#1770](https://github.com/DEFRA/waste-exemptions-back-office/pull/1770) ([brujeo](https://github.com/brujeo))
- \[RUBY-3756\] Add current balance display to charge adjustment page [\#1765](https://github.com/DEFRA/waste-exemptions-back-office/pull/1765) ([brujeo](https://github.com/brujeo))
- Feature/ruby 3758 wex charging payment summary page dates inc dec charge content updates [\#1764](https://github.com/DEFRA/waste-exemptions-back-office/pull/1764) ([brujeo](https://github.com/brujeo))
- Feature/ruby 3744 wex charging bo capture address change information [\#1763](https://github.com/DEFRA/waste-exemptions-back-office/pull/1763) ([brujeo](https://github.com/brujeo))
- Refactor the way reason\_for\_change is shown in RegistrationChangeHistoryService [\#1746](https://github.com/DEFRA/waste-exemptions-back-office/pull/1746) ([brujeo](https://github.com/brujeo))
- Feature/ruby 3745 wex fo record email address of self serve edit [\#1742](https://github.com/DEFRA/waste-exemptions-back-office/pull/1742) ([brujeo](https://github.com/brujeo))
- \[RUBY-3467\] Limit multiple refunds of the same payment [\#1737](https://github.com/DEFRA/waste-exemptions-back-office/pull/1737) ([jjromeo](https://github.com/jjromeo))
- \[RUBY-3720\] Refactor RefreshCompaniesHouseNameService to set reason for change [\#1735](https://github.com/DEFRA/waste-exemptions-back-office/pull/1735) ([brujeo](https://github.com/brujeo))
- Feature/ruby 3541 wex bau display registration changes audit trail [\#1732](https://github.com/DEFRA/waste-exemptions-back-office/pull/1732) ([brujeo](https://github.com/brujeo))
- Feature/ruby 3684 wex bau capture registration edit reason [\#1727](https://github.com/DEFRA/waste-exemptions-back-office/pull/1727) ([brujeo](https://github.com/brujeo))
- Feature/ruby 3699 toggle renewal link [\#1725](https://github.com/DEFRA/waste-exemptions-back-office/pull/1725) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- \[RUBY-3674\] background job to check registration balance [\#1704](https://github.com/DEFRA/waste-exemptions-back-office/pull/1704) ([brujeo](https://github.com/brujeo))
- \[RUBY-3675\] Update renewal reminder emails to direct users to new registration [\#1703](https://github.com/DEFRA/waste-exemptions-back-office/pull/1703) ([jjromeo](https://github.com/jjromeo))
- \[RUBY-3690\] make new registration workflow to start from location page [\#1700](https://github.com/DEFRA/waste-exemptions-back-office/pull/1700) ([brujeo](https://github.com/brujeo))
- \[RUBY-3693\] Add rake task to delete all transient registrations [\#1696](https://github.com/DEFRA/waste-exemptions-back-office/pull/1696) ([jjromeo](https://github.com/jjromeo))
- \[RUBY-3629\] Update waste\_exemptions\_engine to revision 45d6517 [\#1683](https://github.com/DEFRA/waste-exemptions-back-office/pull/1683) ([brujeo](https://github.com/brujeo))
- \[RUBY-3646\] Add permission for resetting transient registrations [\#1682](https://github.com/DEFRA/waste-exemptions-back-office/pull/1682) ([jjromeo](https://github.com/jjromeo))

**Fixed bugs:**

- \[RUBY-3524\] refactored available\_refund\_amount method to take reversed payments into account [\#1799](https://github.com/DEFRA/waste-exemptions-back-office/pull/1799) ([brujeo](https://github.com/brujeo))
- Fix/ruby 3772 adjustments [\#1795](https://github.com/DEFRA/waste-exemptions-back-office/pull/1795) ([brujeo](https://github.com/brujeo))
- Add webhook fixtures required by defra-ruby-mocks [\#1791](https://github.com/DEFRA/waste-exemptions-back-office/pull/1791) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- fix/RUBY-3761\_bands [\#1779](https://github.com/DEFRA/waste-exemptions-back-office/pull/1779) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Refactor version exclusion logic in RegistrationChangeHistoryService [\#1774](https://github.com/DEFRA/waste-exemptions-back-office/pull/1774) ([brujeo](https://github.com/brujeo))
- Load faker gem in production for test helper [\#1773](https://github.com/DEFRA/waste-exemptions-back-office/pull/1773) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Fix/ruby 3712 wex finance export refunds are missing refund type [\#1740](https://github.com/DEFRA/waste-exemptions-back-office/pull/1740) ([brujeo](https://github.com/brujeo))
- Prevent finance users from exporting data [\#1731](https://github.com/DEFRA/waste-exemptions-back-office/pull/1731) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- \[RUBY-3675\] Update renewal email to use `TemporaryFirstRenewalReminderService` [\#1710](https://github.com/DEFRA/waste-exemptions-back-office/pull/1710) ([jjromeo](https://github.com/jjromeo))
- \[RUBY-3658\] Fix balance calculation in finance data report presenters [\#1706](https://github.com/DEFRA/waste-exemptions-back-office/pull/1706) ([brujeo](https://github.com/brujeo))
- Show exemptions summaries, not descriptions, in charge catalogue [\#1685](https://github.com/DEFRA/waste-exemptions-back-office/pull/1685) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

**Merged pull requests:**

- Release/v3.0.0 [\#1824](https://github.com/DEFRA/waste-exemptions-back-office/pull/1824) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Version 3.0.0 [\#1821](https://github.com/DEFRA/waste-exemptions-back-office/pull/1821) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- \[RUBY-3858\] Update waste\_exemptions\_engine gem revision to a1c07c00a6b362be95bdbca1c712869a3f01eb44 in Gemfile.lock [\#1820](https://github.com/DEFRA/waste-exemptions-back-office/pull/1820) ([jjromeo](https://github.com/jjromeo))
- Update govpay mocks config [\#1814](https://github.com/DEFRA/waste-exemptions-back-office/pull/1814) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Chore/govpay mocks config [\#1812](https://github.com/DEFRA/waste-exemptions-back-office/pull/1812) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Update waste\_exemptions\_engine to the latest version [\#1810](https://github.com/DEFRA/waste-exemptions-back-office/pull/1810) ([brujeo](https://github.com/brujeo))
- \[RUBY-3802\] Update waste\_exemptions\_engine gem revision in Gemfile.lock to latest main branch commit [\#1804](https://github.com/DEFRA/waste-exemptions-back-office/pull/1804) ([jjromeo](https://github.com/jjromeo))
- Update waste\_exemptions\_engine to the latest version [\#1803](https://github.com/DEFRA/waste-exemptions-back-office/pull/1803) ([brujeo](https://github.com/brujeo))
- Update waste\_exemptions\_engine to the latest version [\#1798](https://github.com/DEFRA/waste-exemptions-back-office/pull/1798) ([brujeo](https://github.com/brujeo))
- Bump defra\_ruby\_mocks from 5.1.2 to 5.1.3 [\#1790](https://github.com/DEFRA/waste-exemptions-back-office/pull/1790) ([dependabot[bot]](https://github.com/apps/dependabot))
- Update waste\_exemptions\_engine revision [\#1788](https://github.com/DEFRA/waste-exemptions-back-office/pull/1788) ([brujeo](https://github.com/brujeo))
- Bump defra\_ruby\_mocks from 5.1.1 to 5.1.2 [\#1786](https://github.com/DEFRA/waste-exemptions-back-office/pull/1786) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump defra\_ruby\_mocks from 5.1.0 to 5.1.1 [\#1784](https://github.com/DEFRA/waste-exemptions-back-office/pull/1784) ([dependabot[bot]](https://github.com/apps/dependabot))
- Update waste\_exemptions\_engine to the latest version [\#1782](https://github.com/DEFRA/waste-exemptions-back-office/pull/1782) ([brujeo](https://github.com/brujeo))
- Update waste\_exemptions\_engine to the latest version [\#1780](https://github.com/DEFRA/waste-exemptions-back-office/pull/1780) ([brujeo](https://github.com/brujeo))
- Update waste\_exemptions\_engine gem revision in Gemfile.lock [\#1778](https://github.com/DEFRA/waste-exemptions-back-office/pull/1778) ([brujeo](https://github.com/brujeo))
- Update engine and add instructions for remote debugging [\#1777](https://github.com/DEFRA/waste-exemptions-back-office/pull/1777) ([brujeo](https://github.com/brujeo))
- \[RUBY-3784\] Update waste\_exemptions\_engine gem revision in Gemfile.lock to e27afe1c0bb63f558ce14e587ce520c0d2b7f8bf [\#1772](https://github.com/DEFRA/waste-exemptions-back-office/pull/1772) ([jjromeo](https://github.com/jjromeo))
- Chore/ruby 3761 test helper add charges [\#1771](https://github.com/DEFRA/waste-exemptions-back-office/pull/1771) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Update passenger gem version constraints to exclude 6.0.27 [\#1769](https://github.com/DEFRA/waste-exemptions-back-office/pull/1769) ([brujeo](https://github.com/brujeo))
- Revert "Bump passenger from 6.0.22 to 6.0.27" [\#1768](https://github.com/DEFRA/waste-exemptions-back-office/pull/1768) ([brujeo](https://github.com/brujeo))
- bump engine version [\#1762](https://github.com/DEFRA/waste-exemptions-back-office/pull/1762) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump devise\_invitable from 2.0.9 to 2.0.10 [\#1761](https://github.com/DEFRA/waste-exemptions-back-office/pull/1761) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump passenger from 6.0.22 to 6.0.27 [\#1760](https://github.com/DEFRA/waste-exemptions-back-office/pull/1760) ([dependabot[bot]](https://github.com/apps/dependabot))
- Update dependabot configuration to include additional branch check [\#1759](https://github.com/DEFRA/waste-exemptions-back-office/pull/1759) ([brujeo](https://github.com/brujeo))
- Bump net-imap from 0.5.6 to 0.5.7 [\#1758](https://github.com/DEFRA/waste-exemptions-back-office/pull/1758) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump nokogiri from 1.18.7 to 1.18.8 [\#1757](https://github.com/DEFRA/waste-exemptions-back-office/pull/1757) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump bullet from 8.0.1 to 8.0.5 [\#1756](https://github.com/DEFRA/waste-exemptions-back-office/pull/1756) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rspec from 3.5.0 to 3.6.0 [\#1754](https://github.com/DEFRA/waste-exemptions-back-office/pull/1754) ([dependabot[bot]](https://github.com/apps/dependabot))
- Update dependabot setup [\#1753](https://github.com/DEFRA/waste-exemptions-back-office/pull/1753) ([brujeo](https://github.com/brujeo))
- Bump dependencies in Gemfile.lock to latest versions [\#1752](https://github.com/DEFRA/waste-exemptions-back-office/pull/1752) ([brujeo](https://github.com/brujeo))
- Bump waste\_exemptions\_engine from `e58979a` to `0223507` [\#1748](https://github.com/DEFRA/waste-exemptions-back-office/pull/1748) ([dependabot[bot]](https://github.com/apps/dependabot))
- Upgrade ubuntu version in ci.yml [\#1741](https://github.com/DEFRA/waste-exemptions-back-office/pull/1741) ([brujeo](https://github.com/brujeo))
- Bump rubocop-rails from 2.30.3 to 2.31.0 [\#1738](https://github.com/DEFRA/waste-exemptions-back-office/pull/1738) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump faraday-retry from 2.2.1 to 2.3.0 [\#1736](https://github.com/DEFRA/waste-exemptions-back-office/pull/1736) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump pry-byebug from 3.10.1 to 3.11.0 [\#1733](https://github.com/DEFRA/waste-exemptions-back-office/pull/1733) ([dependabot[bot]](https://github.com/apps/dependabot))
- Upgrade to Rails 7.2.2.1 [\#1729](https://github.com/DEFRA/waste-exemptions-back-office/pull/1729) ([jjromeo](https://github.com/jjromeo))
- Bump waste\_exemptions\_engine from `4cf93a8` to `b28af3c` [\#1726](https://github.com/DEFRA/waste-exemptions-back-office/pull/1726) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `b247656` to `4cf93a8` [\#1723](https://github.com/DEFRA/waste-exemptions-back-office/pull/1723) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `44621ff` to `b247656` [\#1720](https://github.com/DEFRA/waste-exemptions-back-office/pull/1720) ([dependabot[bot]](https://github.com/apps/dependabot))
- Chore/postgres v15 rspec [\#1719](https://github.com/DEFRA/waste-exemptions-back-office/pull/1719) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump waste\_exemptions\_engine from `57dabae` to `44621ff` [\#1717](https://github.com/DEFRA/waste-exemptions-back-office/pull/1717) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `b355b8e` to `57dabae` [\#1716](https://github.com/DEFRA/waste-exemptions-back-office/pull/1716) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `4417f1c` to `b355b8e` [\#1714](https://github.com/DEFRA/waste-exemptions-back-office/pull/1714) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `4f82fe7` to `4417f1c` [\#1712](https://github.com/DEFRA/waste-exemptions-back-office/pull/1712) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `04f5357` to `4f82fe7` [\#1711](https://github.com/DEFRA/waste-exemptions-back-office/pull/1711) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-capybara from 2.22.0 to 2.22.1 [\#1709](https://github.com/DEFRA/waste-exemptions-back-office/pull/1709) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump spring from 4.2.1 to 4.3.0 [\#1708](https://github.com/DEFRA/waste-exemptions-back-office/pull/1708) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump json from 2.10.1 to 2.10.2 [\#1707](https://github.com/DEFRA/waste-exemptions-back-office/pull/1707) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `8661d5b` to `04f5357` [\#1705](https://github.com/DEFRA/waste-exemptions-back-office/pull/1705) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rack from 2.2.12 to 2.2.13 [\#1702](https://github.com/DEFRA/waste-exemptions-back-office/pull/1702) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `c066824` to `8661d5b` [\#1701](https://github.com/DEFRA/waste-exemptions-back-office/pull/1701) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-capybara from 2.21.0 to 2.22.0 [\#1699](https://github.com/DEFRA/waste-exemptions-back-office/pull/1699) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump webmock from 3.25.0 to 3.25.1 [\#1698](https://github.com/DEFRA/waste-exemptions-back-office/pull/1698) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `1a9fb87` to `c066824` [\#1695](https://github.com/DEFRA/waste-exemptions-back-office/pull/1695) ([dependabot[bot]](https://github.com/apps/dependabot))
- Feature/ruby 3690 wex bo remove private beta actions and code cleanup [\#1694](https://github.com/DEFRA/waste-exemptions-back-office/pull/1694) ([brujeo](https://github.com/brujeo))
- Bump waste\_exemptions\_engine from `b48a2a7` to `1a9fb87` [\#1693](https://github.com/DEFRA/waste-exemptions-back-office/pull/1693) ([dependabot[bot]](https://github.com/apps/dependabot))
- Merge mvp intp main [\#1692](https://github.com/DEFRA/waste-exemptions-back-office/pull/1692) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump waste\_exemptions\_engine from `1b21c96` to `803fac4` [\#1689](https://github.com/DEFRA/waste-exemptions-back-office/pull/1689) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump uri from 1.0.2 to 1.0.3 [\#1688](https://github.com/DEFRA/waste-exemptions-back-office/pull/1688) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `45d6517` to `1b21c96` [\#1687](https://github.com/DEFRA/waste-exemptions-back-office/pull/1687) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `d2cfb29` to `81e492c` [\#1681](https://github.com/DEFRA/waste-exemptions-back-office/pull/1681) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `06b7d88` to `d2cfb29` [\#1680](https://github.com/DEFRA/waste-exemptions-back-office/pull/1680) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.20.4](https://github.com/defra/waste-exemptions-back-office/tree/v2.20.4) (2025-03-26)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.20.3...v2.20.4)

## [v2.20.3](https://github.com/defra/waste-exemptions-back-office/tree/v2.20.3) (2025-03-14)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.20.2...v2.20.3)

## [v2.20.2](https://github.com/defra/waste-exemptions-back-office/tree/v2.20.2) (2025-02-27)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.20.1...v2.20.2)

**Implemented enhancements:**

- \[RUBY-3671 & RUBY-3672\] rake tasks to extend expiry dates [\#1676](https://github.com/DEFRA/waste-exemptions-back-office/pull/1676) ([brujeo](https://github.com/brujeo))
- RUBY 3676 wex charging revert stop renewal communications for private beta participants [\#1673](https://github.com/DEFRA/waste-exemptions-back-office/pull/1673) ([jjromeo](https://github.com/jjromeo))

**Fixed bugs:**

- Fix/ruby 3667 missing site address [\#1674](https://github.com/DEFRA/waste-exemptions-back-office/pull/1674) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

**Merged pull requests:**

- Update CHANGELOG [\#1679](https://github.com/DEFRA/waste-exemptions-back-office/pull/1679) ([brujeo](https://github.com/brujeo))
- Chore/ruby 3655 epr export error handling [\#1678](https://github.com/DEFRA/waste-exemptions-back-office/pull/1678) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump waste\_exemptions\_engine from `c6cc0ec` to `06b7d88` [\#1677](https://github.com/DEFRA/waste-exemptions-back-office/pull/1677) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `658bc16` to `c6cc0ec` [\#1670](https://github.com/DEFRA/waste-exemptions-back-office/pull/1670) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump selenium-webdriver from 4.28.0 to 4.29.1 [\#1667](https://github.com/DEFRA/waste-exemptions-back-office/pull/1667) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rspec from 3.4.0 to 3.5.0 [\#1646](https://github.com/DEFRA/waste-exemptions-back-office/pull/1646) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rspec-rails from 7.1.0 to 7.1.1 [\#1632](https://github.com/DEFRA/waste-exemptions-back-office/pull/1632) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.20.1](https://github.com/defra/waste-exemptions-back-office/tree/v2.20.1) (2025-02-24)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.20.0...v2.20.1)

**Implemented enhancements:**

- \[RUBY-3640\] Refactor charge breakdown layout and styling [\#1660](https://github.com/DEFRA/waste-exemptions-back-office/pull/1660) ([brujeo](https://github.com/brujeo))
- \[RUBY-3640\] hiding non-farmer exemptions from charge breakdown when non are selected [\#1656](https://github.com/DEFRA/waste-exemptions-back-office/pull/1656) ([brujeo](https://github.com/brujeo))
- \[RUBY-3640\] add charging breakdown for farming exemptions [\#1654](https://github.com/DEFRA/waste-exemptions-back-office/pull/1654) ([brujeo](https://github.com/brujeo))
- feature/RUBY-3636\_start\_new\_charged\_registration [\#1652](https://github.com/DEFRA/waste-exemptions-back-office/pull/1652) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

**Fixed bugs:**

- \[RUBY-3658\] Refactor payment row presenter to handle negative payment amounts and calculate balance [\#1664](https://github.com/DEFRA/waste-exemptions-back-office/pull/1664) ([brujeo](https://github.com/brujeo))
- \[RUBY-3658\] refactor finance data report  to show charge adjustment as either positive or negative [\#1662](https://github.com/DEFRA/waste-exemptions-back-office/pull/1662) ([brujeo](https://github.com/brujeo))
- Suppress date range h2 if no start or end date defined [\#1653](https://github.com/DEFRA/waste-exemptions-back-office/pull/1653) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Fix/ruby 3234 pb analytics track dropoff [\#1650](https://github.com/DEFRA/waste-exemptions-back-office/pull/1650) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- RUBY 3644 wex charging stop renewal communications for private beta participants [\#1649](https://github.com/DEFRA/waste-exemptions-back-office/pull/1649) ([jjromeo](https://github.com/jjromeo))

**Merged pull requests:**

- Update CHANGELOG [\#1668](https://github.com/DEFRA/waste-exemptions-back-office/pull/1668) ([jjromeo](https://github.com/jjromeo))
- Bump waste\_exemptions\_engine from `394ab72` to `658bc16` [\#1666](https://github.com/DEFRA/waste-exemptions-back-office/pull/1666) ([dependabot[bot]](https://github.com/apps/dependabot))
- \[RUBY-3618\] Update schema to add `temp_add_additional_non_farm_exemptions` column [\#1659](https://github.com/DEFRA/waste-exemptions-back-office/pull/1659) ([jjromeo](https://github.com/jjromeo))
- Bump waste\_exemptions\_engine from `0fdb680` to `394ab72` [\#1658](https://github.com/DEFRA/waste-exemptions-back-office/pull/1658) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `8fdfb55` to `0fdb680` [\#1655](https://github.com/DEFRA/waste-exemptions-back-office/pull/1655) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.20.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.20.0) (2025-02-17)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.19.0...v2.20.0)

**Implemented enhancements:**

- \[RUBY-3644\] Stop sending renewal communications to beta participants [\#1645](https://github.com/DEFRA/waste-exemptions-back-office/pull/1645) ([jjromeo](https://github.com/jjromeo))
- \[RUBY-3617\] updated exemptions [\#1643](https://github.com/DEFRA/waste-exemptions-back-office/pull/1643) ([brujeo](https://github.com/brujeo))
- \[RUBY-3645\] remove renewal window constraint from Send private beta invite email action [\#1642](https://github.com/DEFRA/waste-exemptions-back-office/pull/1642) ([brujeo](https://github.com/brujeo))
- Feature/ruby 3492 add support for farming exemptions [\#1641](https://github.com/DEFRA/waste-exemptions-back-office/pull/1641) ([brujeo](https://github.com/brujeo))
- ruby-3492: wex charging daily finance data export [\#1634](https://github.com/DEFRA/waste-exemptions-back-office/pull/1634) ([brujeo](https://github.com/brujeo))
- Feature/ruby 3234 analytics track pb [\#1631](https://github.com/DEFRA/waste-exemptions-back-office/pull/1631) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- RUBY 3406 wex company name rechecks via companies house re checking data cleanse [\#1497](https://github.com/DEFRA/waste-exemptions-back-office/pull/1497) ([jjromeo](https://github.com/jjromeo))

**Fixed bugs:**

- fix/RUBY-3234\_analytics\_track\_pb [\#1640](https://github.com/DEFRA/waste-exemptions-back-office/pull/1640) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Feature/ruby 3234 analytics track pb [\#1638](https://github.com/DEFRA/waste-exemptions-back-office/pull/1638) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Feature/ruby 3234 analytics track pb [\#1635](https://github.com/DEFRA/waste-exemptions-back-office/pull/1635) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

**Merged pull requests:**

- Update CHANGELOG [\#1648](https://github.com/DEFRA/waste-exemptions-back-office/pull/1648) ([brujeo](https://github.com/brujeo))
- Bump waste\_exemptions\_engine from `88e3f5f` to `0cc5411` [\#1633](https://github.com/DEFRA/waste-exemptions-back-office/pull/1633) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `bd685a4` to `88e3f5f` [\#1627](https://github.com/DEFRA/waste-exemptions-back-office/pull/1627) ([dependabot[bot]](https://github.com/apps/dependabot))
- tech debt: adding exemptions.csv and refactoring seed job to use it [\#1625](https://github.com/DEFRA/waste-exemptions-back-office/pull/1625) ([brujeo](https://github.com/brujeo))

## [v2.19.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.19.0) (2025-02-03)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.18.1...v2.19.0)

**Implemented enhancements:**

- ruby-3598: seed task to populate/update exemptions data [\#1617](https://github.com/DEFRA/waste-exemptions-back-office/pull/1617) ([brujeo](https://github.com/brujeo))
- \[RUBY-3589\] Add more email personalisation details to PrivateBetaInviteEmailService [\#1609](https://github.com/DEFRA/waste-exemptions-back-office/pull/1609) ([brujeo](https://github.com/brujeo))
- Include new\_charged\_registrations in "New registrations" search results [\#1608](https://github.com/DEFRA/waste-exemptions-back-office/pull/1608) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Add private\_beta\_feedback\_url [\#1604](https://github.com/DEFRA/waste-exemptions-back-office/pull/1604) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- RUBY-3554: Manage Private Beta participants page [\#1603](https://github.com/DEFRA/waste-exemptions-back-office/pull/1603) ([brujeo](https://github.com/brujeo))
- Feature/ruby 3559 3607 private beta resource flash [\#1599](https://github.com/DEFRA/waste-exemptions-back-office/pull/1599) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- RUBY-3589: post qa additions [\#1598](https://github.com/DEFRA/waste-exemptions-back-office/pull/1598) ([brujeo](https://github.com/brujeo))
- RUBY-3589: wex charging private beta send invite email [\#1597](https://github.com/DEFRA/waste-exemptions-back-office/pull/1597) ([brujeo](https://github.com/brujeo))
- RUBY 3571 wex charging bo assisted digital registrations [\#1593](https://github.com/DEFRA/waste-exemptions-back-office/pull/1593) ([jjromeo](https://github.com/jjromeo))
- Add beta participants seed data [\#1591](https://github.com/DEFRA/waste-exemptions-back-office/pull/1591) ([brujeo](https://github.com/brujeo))
- RUBY 3483 wex deactivation of back office users based upon last log in time [\#1579](https://github.com/DEFRA/waste-exemptions-back-office/pull/1579) ([jjromeo](https://github.com/jjromeo))

**Fixed bugs:**

- \[RUBY-3605\] Refactor administrable roles service to use consistent spelling for policy adviser [\#1621](https://github.com/DEFRA/waste-exemptions-back-office/pull/1621) ([brujeo](https://github.com/brujeo))
- Fix back link in new\_registrations show view [\#1619](https://github.com/DEFRA/waste-exemptions-back-office/pull/1619) ([brujeo](https://github.com/brujeo))
- Fix/ruby 3558 nil orders error [\#1618](https://github.com/DEFRA/waste-exemptions-back-office/pull/1618) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- \[RUBY-3571\] Add `invited_at` timestamp to BetaParticipant creation [\#1616](https://github.com/DEFRA/waste-exemptions-back-office/pull/1616) ([jjromeo](https://github.com/jjromeo))
- \[RUBY-3571\] Add `invited_at` timestamp to `BetaParticipant` creation [\#1613](https://github.com/DEFRA/waste-exemptions-back-office/pull/1613) ([jjromeo](https://github.com/jjromeo))
- Feature/ruby 3579 find pb in progress regs [\#1612](https://github.com/DEFRA/waste-exemptions-back-office/pull/1612) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- \[RUBY-3571\] Fix link display bug by updating CSS class in resource details partial. [\#1611](https://github.com/DEFRA/waste-exemptions-back-office/pull/1611) ([jjromeo](https://github.com/jjromeo))
- Fix/ruby 3559 3607 private beta resource flash [\#1610](https://github.com/DEFRA/waste-exemptions-back-office/pull/1610) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Use govuk notification banner instead of flash message [\#1606](https://github.com/DEFRA/waste-exemptions-back-office/pull/1606) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Add config.host [\#1594](https://github.com/DEFRA/waste-exemptions-back-office/pull/1594) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Fix/ruby 3296 display registration details [\#1584](https://github.com/DEFRA/waste-exemptions-back-office/pull/1584) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

**Merged pull requests:**

- Version 2.19.0 [\#1624](https://github.com/DEFRA/waste-exemptions-back-office/pull/1624) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump waste\_exemptions\_engine from `3611a5a` to `f2102c2` [\#1623](https://github.com/DEFRA/waste-exemptions-back-office/pull/1623) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `4c76706` to `3611a5a` [\#1622](https://github.com/DEFRA/waste-exemptions-back-office/pull/1622) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `62e8a0d` to `4c76706` [\#1620](https://github.com/DEFRA/waste-exemptions-back-office/pull/1620) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `a6757e2` to `84165f0` [\#1615](https://github.com/DEFRA/waste-exemptions-back-office/pull/1615) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `21eac2e` to `a6757e2` [\#1614](https://github.com/DEFRA/waste-exemptions-back-office/pull/1614) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `cd5ee70` to `21eac2e` [\#1607](https://github.com/DEFRA/waste-exemptions-back-office/pull/1607) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `49cbf39` to `5536e73` [\#1602](https://github.com/DEFRA/waste-exemptions-back-office/pull/1602) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `9d760d8` to `93aac8a` [\#1595](https://github.com/DEFRA/waste-exemptions-back-office/pull/1595) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `eb6e50c` to `9d760d8` [\#1592](https://github.com/DEFRA/waste-exemptions-back-office/pull/1592) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `012b94e` to `eb6e50c` [\#1590](https://github.com/DEFRA/waste-exemptions-back-office/pull/1590) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump selenium-webdriver from 4.27.0 to 4.28.0 [\#1589](https://github.com/DEFRA/waste-exemptions-back-office/pull/1589) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rspec from 3.3.0 to 3.4.0 [\#1587](https://github.com/DEFRA/waste-exemptions-back-office/pull/1587) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rails from 2.28.0 to 2.29.0 [\#1586](https://github.com/DEFRA/waste-exemptions-back-office/pull/1586) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.18.1](https://github.com/defra/waste-exemptions-back-office/tree/v2.18.1) (2025-01-21)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.18.0...v2.18.1)

**Implemented enhancements:**

- \[RUBY-3596\] Add feature to promote back office user to service manager [\#1585](https://github.com/DEFRA/waste-exemptions-back-office/pull/1585) ([jjromeo](https://github.com/jjromeo))
- \[RUBY-3539\] Update communication role permission to `send_comms` [\#1583](https://github.com/DEFRA/waste-exemptions-back-office/pull/1583) ([jjromeo](https://github.com/jjromeo))

**Merged pull requests:**

- Version 2.18.1 [\#1588](https://github.com/DEFRA/waste-exemptions-back-office/pull/1588) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

## [v2.18.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.18.0) (2025-01-14)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.17.0...v2.18.0)

**Implemented enhancements:**

- \[RUBY-2703\] Update adjustment\_types.en.yml to improve charge adjustment labels and hints [\#1578](https://github.com/DEFRA/waste-exemptions-back-office/pull/1578) ([brujeo](https://github.com/brujeo))
- \[RUBY-2703\] Updating H1 text, option texts and hints [\#1577](https://github.com/DEFRA/waste-exemptions-back-office/pull/1577) ([brujeo](https://github.com/brujeo))
- Feature/ruby 3296 display registration details [\#1573](https://github.com/DEFRA/waste-exemptions-back-office/pull/1573) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- RUBY-3388-3389-3449-3453-3451-3448: Adding new roles and adjusting existing ones [\#1559](https://github.com/DEFRA/waste-exemptions-back-office/pull/1559) ([brujeo](https://github.com/brujeo))
- RUBY-3384: Add service\_manager role [\#1550](https://github.com/DEFRA/waste-exemptions-back-office/pull/1550) ([brujeo](https://github.com/brujeo))
- RUBY-3055: Seed data for waste activities [\#1536](https://github.com/DEFRA/waste-exemptions-back-office/pull/1536) ([brujeo](https://github.com/brujeo))
- Chore/ruby 3465 remove super agent role [\#1532](https://github.com/DEFRA/waste-exemptions-back-office/pull/1532) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- RUBY 2703 wex charging bo 3 1 2 increase or decrease a charge page [\#1527](https://github.com/DEFRA/waste-exemptions-back-office/pull/1527) ([jjromeo](https://github.com/jjromeo))
- \[RUBY-2704\] Fix bug where refund can be higher than balance [\#1526](https://github.com/DEFRA/waste-exemptions-back-office/pull/1526) ([jjromeo](https://github.com/jjromeo))
- Feature/ruby 2701 payment details [\#1524](https://github.com/DEFRA/waste-exemptions-back-office/pull/1524) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Feature/ruby 2705 add a payment page improvements [\#1523](https://github.com/DEFRA/waste-exemptions-back-office/pull/1523) ([brujeo](https://github.com/brujeo))
- RUBY 2713 wex charging bo 3 1 5 reverse a payment page [\#1522](https://github.com/DEFRA/waste-exemptions-back-office/pull/1522) ([jjromeo](https://github.com/jjromeo))
- RUBY-3456: WEX charging - account balance calculations [\#1521](https://github.com/DEFRA/waste-exemptions-back-office/pull/1521) ([brujeo](https://github.com/brujeo))
- RUBY 2704 wex charging bo 3 1 3 refund a payment page [\#1515](https://github.com/DEFRA/waste-exemptions-back-office/pull/1515) ([jjromeo](https://github.com/jjromeo))
- RUBY-2705: WEX charging - Add a payment page [\#1514](https://github.com/DEFRA/waste-exemptions-back-office/pull/1514) ([brujeo](https://github.com/brujeo))
- Feature/ruby 2701 payment details [\#1507](https://github.com/DEFRA/waste-exemptions-back-office/pull/1507) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- \[RUBY-3414\] Add payment details page and link to registrations [\#1500](https://github.com/DEFRA/waste-exemptions-back-office/pull/1500) ([jjromeo](https://github.com/jjromeo))

**Fixed bugs:**

- Fix/ruby 3296 display registration details [\#1576](https://github.com/DEFRA/waste-exemptions-back-office/pull/1576) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Fix/adjusting roles and permissions [\#1564](https://github.com/DEFRA/waste-exemptions-back-office/pull/1564) ([brujeo](https://github.com/brujeo))
- \[RUBY-2713\] Add authorization to RecordReversalsController and fix Accessibility issue [\#1558](https://github.com/DEFRA/waste-exemptions-back-office/pull/1558) ([jjromeo](https://github.com/jjromeo))
- \[RUBY-2713\] Add titles to 'Record a refund' and 'Reverse a payment' forms in locales [\#1556](https://github.com/DEFRA/waste-exemptions-back-office/pull/1556) ([jjromeo](https://github.com/jjromeo))
- Add content to hidden headers [\#1553](https://github.com/DEFRA/waste-exemptions-back-office/pull/1553) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Feature/ruby 2701 payment details [\#1549](https://github.com/DEFRA/waste-exemptions-back-office/pull/1549) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- \[RUBY-2704\] Fix scoping issues in `Payment` model and update tests [\#1548](https://github.com/DEFRA/waste-exemptions-back-office/pull/1548) ([jjromeo](https://github.com/jjromeo))
- Update error message for refund amount validation [\#1546](https://github.com/DEFRA/waste-exemptions-back-office/pull/1546) ([jjromeo](https://github.com/jjromeo))
- \[RUBY-2704\] Fix presenters bug in `RecordRefundsController` and views [\#1543](https://github.com/DEFRA/waste-exemptions-back-office/pull/1543) ([jjromeo](https://github.com/jjromeo))
- Fixes to Rounding defect and misleading refund amount [\#1542](https://github.com/DEFRA/waste-exemptions-back-office/pull/1542) ([jjromeo](https://github.com/jjromeo))

**Merged pull requests:**

- Update CHANGELOG [\#1581](https://github.com/DEFRA/waste-exemptions-back-office/pull/1581) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump waste\_exemptions\_engine from `f3f54ec` to `012b94e` [\#1572](https://github.com/DEFRA/waste-exemptions-back-office/pull/1572) ([dependabot[bot]](https://github.com/apps/dependabot))
- Update charge seed values [\#1571](https://github.com/DEFRA/waste-exemptions-back-office/pull/1571) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump waste\_exemptions\_engine from `510f091` to `f3f54ec` [\#1570](https://github.com/DEFRA/waste-exemptions-back-office/pull/1570) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `f9448ef` to `510f091` [\#1569](https://github.com/DEFRA/waste-exemptions-back-office/pull/1569) ([dependabot[bot]](https://github.com/apps/dependabot))
- Chore/ruby 3441 companies house gem [\#1567](https://github.com/DEFRA/waste-exemptions-back-office/pull/1567) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump waste\_exemptions\_engine from `be25d2d` to `7650caa` [\#1561](https://github.com/DEFRA/waste-exemptions-back-office/pull/1561) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `3245209` to `be25d2d` [\#1547](https://github.com/DEFRA/waste-exemptions-back-office/pull/1547) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump webrick from 1.9.0 to 1.9.1 [\#1539](https://github.com/DEFRA/waste-exemptions-back-office/pull/1539) ([dependabot[bot]](https://github.com/apps/dependabot))
- \[RUBY-2703\] Update schema to include charge adjustments table and modify payments table [\#1535](https://github.com/DEFRA/waste-exemptions-back-office/pull/1535) ([jjromeo](https://github.com/jjromeo))
- RUBY 2704 payment details presenter refactor [\#1534](https://github.com/DEFRA/waste-exemptions-back-office/pull/1534) ([jjromeo](https://github.com/jjromeo))
- Bump selenium-webdriver from 4.26.0 to 4.27.0 [\#1531](https://github.com/DEFRA/waste-exemptions-back-office/pull/1531) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.17.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.17.0) (2024-10-30)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.16.0...v2.17.0)

**Implemented enhancements:**

- Feature/ruby 3347 add epr fields [\#1485](https://github.com/DEFRA/waste-exemptions-back-office/pull/1485) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Feature/ruby 3298 search order [\#1479](https://github.com/DEFRA/waste-exemptions-back-office/pull/1479) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- RUBY-3297: Ability to track report downloads + export download history [\#1473](https://github.com/DEFRA/waste-exemptions-back-office/pull/1473) ([brujeo](https://github.com/brujeo))

**Fixed bugs:**

- Move bulk\_seed logic from a rake task to a spec [\#1484](https://github.com/DEFRA/waste-exemptions-back-office/pull/1484) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

**Merged pull requests:**

- Update CHANGELOG [\#1510](https://github.com/DEFRA/waste-exemptions-back-office/pull/1510) ([brujeo](https://github.com/brujeo))
- Bump waste\_exemptions\_engine from `1217660` to `d98f4cf` [\#1508](https://github.com/DEFRA/waste-exemptions-back-office/pull/1508) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump pg from 1.5.8 to 1.5.9 [\#1506](https://github.com/DEFRA/waste-exemptions-back-office/pull/1506) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rails from 2.26.2 to 2.27.0 [\#1505](https://github.com/DEFRA/waste-exemptions-back-office/pull/1505) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump database\_cleaner from 2.0.2 to 2.1.0 [\#1504](https://github.com/DEFRA/waste-exemptions-back-office/pull/1504) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `5878a91` to `1217660` [\#1503](https://github.com/DEFRA/waste-exemptions-back-office/pull/1503) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rexml from 3.3.8 to 3.3.9 [\#1502](https://github.com/DEFRA/waste-exemptions-back-office/pull/1502) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rspec from 3.0.5 to 3.2.0 [\#1501](https://github.com/DEFRA/waste-exemptions-back-office/pull/1501) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump factory\_bot\_rails from 6.4.3 to 6.4.4 [\#1499](https://github.com/DEFRA/waste-exemptions-back-office/pull/1499) ([dependabot[bot]](https://github.com/apps/dependabot))
- Fix bug by associating charge to band in seeds [\#1498](https://github.com/DEFRA/waste-exemptions-back-office/pull/1498) ([jjromeo](https://github.com/jjromeo))
- Bump faker from 3.4.2 to 3.5.1 [\#1496](https://github.com/DEFRA/waste-exemptions-back-office/pull/1496) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump net-imap from 0.4.16 to 0.5.0 [\#1495](https://github.com/DEFRA/waste-exemptions-back-office/pull/1495) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump actiontext from 7.1.4 to 7.1.4.1 [\#1492](https://github.com/DEFRA/waste-exemptions-back-office/pull/1492) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rack from 2.2.9 to 2.2.10 [\#1490](https://github.com/DEFRA/waste-exemptions-back-office/pull/1490) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump govuk\_design\_system\_formbuilder from 5.6.0 to 5.7.0 [\#1489](https://github.com/DEFRA/waste-exemptions-back-office/pull/1489) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `e4b6b58` to `5878a91` [\#1488](https://github.com/DEFRA/waste-exemptions-back-office/pull/1488) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump webmock from 3.23.1 to 3.24.0 [\#1487](https://github.com/DEFRA/waste-exemptions-back-office/pull/1487) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `7e4ed8d` to `e4b6b58` [\#1480](https://github.com/DEFRA/waste-exemptions-back-office/pull/1480) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `a235b76` to `7e4ed8d` [\#1476](https://github.com/DEFRA/waste-exemptions-back-office/pull/1476) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.16.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.16.0) (2024-09-16)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.15.0...v2.16.0)

**Implemented enhancements:**

- \[RUBY-3162\] ensure that scheduled job start and completion events are being recorded in logs [\#1470](https://github.com/DEFRA/waste-exemptions-back-office/pull/1470) ([brujeo](https://github.com/brujeo))
- \[RUBY-3305\] Refactoring charging scheme creation and update logic + adding band exemption settings [\#1460](https://github.com/DEFRA/waste-exemptions-back-office/pull/1460) ([brujeo](https://github.com/brujeo))
- RUBY-3051 & RUBY-3052 : payment by card and payment via bank transfer [\#1456](https://github.com/DEFRA/waste-exemptions-back-office/pull/1456) ([brujeo](https://github.com/brujeo))
- \[RUBY-3268\] Add exemption handling and improve registration details display [\#1447](https://github.com/DEFRA/waste-exemptions-back-office/pull/1447) ([jjromeo](https://github.com/jjromeo))

**Fixed bugs:**

- Fix/ruby 3292 renewal journey stats [\#1463](https://github.com/DEFRA/waste-exemptions-back-office/pull/1463) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

**Merged pull requests:**

- Release v2.16.0 [\#1474](https://github.com/DEFRA/waste-exemptions-back-office/pull/1474) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- \[RUBY-2856\] Moving faraday-retry gem from dev,test only to global dependencies [\#1472](https://github.com/DEFRA/waste-exemptions-back-office/pull/1472) ([brujeo](https://github.com/brujeo))
- Bump waste\_exemptions\_engine from `64bff64` to `1024c8c` [\#1469](https://github.com/DEFRA/waste-exemptions-back-office/pull/1469) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `505f3f0` to `64bff64` [\#1467](https://github.com/DEFRA/waste-exemptions-back-office/pull/1467) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rails from 2.25.1 to 2.26.1 [\#1466](https://github.com/DEFRA/waste-exemptions-back-office/pull/1466) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rspec from 3.0.4 to 3.0.5 [\#1465](https://github.com/DEFRA/waste-exemptions-back-office/pull/1465) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump paper\_trail from 15.1.0 to 15.2.0 [\#1464](https://github.com/DEFRA/waste-exemptions-back-office/pull/1464) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump pg from 1.5.7 to 1.5.8 [\#1462](https://github.com/DEFRA/waste-exemptions-back-office/pull/1462) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump net-imap from 0.4.15 to 0.4.16 [\#1459](https://github.com/DEFRA/waste-exemptions-back-office/pull/1459) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `7eee941` to `a02b5da` [\#1453](https://github.com/DEFRA/waste-exemptions-back-office/pull/1453) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump net-imap from 0.4.14 to 0.4.15 [\#1452](https://github.com/DEFRA/waste-exemptions-back-office/pull/1452) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rexml from 3.3.4 to 3.3.6 [\#1448](https://github.com/DEFRA/waste-exemptions-back-office/pull/1448) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump vcr from 6.2.0 to 6.3.1 [\#1445](https://github.com/DEFRA/waste-exemptions-back-office/pull/1445) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rspec-rails from 6.1.3 to 6.1.4 [\#1443](https://github.com/DEFRA/waste-exemptions-back-office/pull/1443) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `faa0c8a` to `7eee941` [\#1442](https://github.com/DEFRA/waste-exemptions-back-office/pull/1442) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `589279d` to `faa0c8a` [\#1441](https://github.com/DEFRA/waste-exemptions-back-office/pull/1441) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump govuk\_design\_system\_formbuilder from 5.4.1 to 5.5.0 [\#1439](https://github.com/DEFRA/waste-exemptions-back-office/pull/1439) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump secure\_headers from 6.5.0 to 6.7.0 [\#1438](https://github.com/DEFRA/waste-exemptions-back-office/pull/1438) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rspec from 3.0.3 to 3.0.4 [\#1436](https://github.com/DEFRA/waste-exemptions-back-office/pull/1436) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump defra\_ruby\_template from 3.15.1 to 5.4.1 [\#1382](https://github.com/DEFRA/waste-exemptions-back-office/pull/1382) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.15.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.15.0) (2024-08-05)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.14.0...v2.15.0)

**Implemented enhancements:**

- \[RUBY-3169\] Update schema and add bucket\_type to seeds [\#1419](https://github.com/DEFRA/waste-exemptions-back-office/pull/1419) ([jjromeo](https://github.com/jjromeo))

**Merged pull requests:**

- Release v2.15.0 [\#1435](https://github.com/DEFRA/waste-exemptions-back-office/pull/1435) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- exclude problematic passenger gem version [\#1434](https://github.com/DEFRA/waste-exemptions-back-office/pull/1434) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump waste\_exemptions\_engine from `8b5fe98` to `589279d` [\#1432](https://github.com/DEFRA/waste-exemptions-back-office/pull/1432) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `0555654` to `8b5fe98` [\#1430](https://github.com/DEFRA/waste-exemptions-back-office/pull/1430) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `a76023c` to `0555654` [\#1429](https://github.com/DEFRA/waste-exemptions-back-office/pull/1429) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump notifications-ruby-client from 6.1.0 to 6.2.0 [\#1428](https://github.com/DEFRA/waste-exemptions-back-office/pull/1428) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `5073d8e` to `a76023c` [\#1427](https://github.com/DEFRA/waste-exemptions-back-office/pull/1427) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `4b4d823` to `5073d8e` [\#1426](https://github.com/DEFRA/waste-exemptions-back-office/pull/1426) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `fd451df` to `4b4d823` [\#1425](https://github.com/DEFRA/waste-exemptions-back-office/pull/1425) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump passenger from 6.0.22 to 6.0.23 [\#1424](https://github.com/DEFRA/waste-exemptions-back-office/pull/1424) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `bb68c78` to `fd451df` [\#1423](https://github.com/DEFRA/waste-exemptions-back-office/pull/1423) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump pg from 1.5.6 to 1.5.7 [\#1422](https://github.com/DEFRA/waste-exemptions-back-office/pull/1422) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `2bfbb70` to `bb68c78` [\#1420](https://github.com/DEFRA/waste-exemptions-back-office/pull/1420) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `4dd03d4` to `2bfbb70` [\#1418](https://github.com/DEFRA/waste-exemptions-back-office/pull/1418) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `8e120bd` to `4dd03d4` [\#1417](https://github.com/DEFRA/waste-exemptions-back-office/pull/1417) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `bbb7600` to `8e120bd` [\#1416](https://github.com/DEFRA/waste-exemptions-back-office/pull/1416) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `5c8910a` to `bbb7600` [\#1415](https://github.com/DEFRA/waste-exemptions-back-office/pull/1415) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `45f1126` to `5c8910a` [\#1413](https://github.com/DEFRA/waste-exemptions-back-office/pull/1413) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `8d6ba7f` to `45f1126` [\#1412](https://github.com/DEFRA/waste-exemptions-back-office/pull/1412) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump govuk\_design\_system\_formbuilder from 5.4.0 to 5.4.1 [\#1411](https://github.com/DEFRA/waste-exemptions-back-office/pull/1411) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `baa5424` to `8d6ba7f` [\#1410](https://github.com/DEFRA/waste-exemptions-back-office/pull/1410) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump faker from 3.4.1 to 3.4.2 [\#1408](https://github.com/DEFRA/waste-exemptions-back-office/pull/1408) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump bullet from 7.1.6 to 7.2.0 [\#1405](https://github.com/DEFRA/waste-exemptions-back-office/pull/1405) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rspec from 3.0.2 to 3.0.3 [\#1404](https://github.com/DEFRA/waste-exemptions-back-office/pull/1404) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.14.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.14.0) (2024-07-18)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.13.1...v2.14.0)

**Implemented enhancements:**

- Feature/ruby 3207 export users roles [\#1396](https://github.com/DEFRA/waste-exemptions-back-office/pull/1396) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Feature/ruby 3207 export users roles [\#1392](https://github.com/DEFRA/waste-exemptions-back-office/pull/1392) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Feature/ruby 3207 export users roles [\#1391](https://github.com/DEFRA/waste-exemptions-back-office/pull/1391) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Feature/ruby 3207 export users roles [\#1390](https://github.com/DEFRA/waste-exemptions-back-office/pull/1390) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Feature/ruby 3207 export users roles [\#1389](https://github.com/DEFRA/waste-exemptions-back-office/pull/1389) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Feature/ruby 3207 export users roles [\#1388](https://github.com/DEFRA/waste-exemptions-back-office/pull/1388) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Feature/ruby 3207 export users roles [\#1386](https://github.com/DEFRA/waste-exemptions-back-office/pull/1386) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

**Merged pull requests:**

- Update CHANGELOG [\#1409](https://github.com/DEFRA/waste-exemptions-back-office/pull/1409) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump waste\_exemptions\_engine from `2deec6f` to `baa5424` [\#1407](https://github.com/DEFRA/waste-exemptions-back-office/pull/1407) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `b91cd52` to `2deec6f` [\#1406](https://github.com/DEFRA/waste-exemptions-back-office/pull/1406) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `ce676bc` to `b91cd52` [\#1403](https://github.com/DEFRA/waste-exemptions-back-office/pull/1403) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `23bf381` to `ce676bc` [\#1402](https://github.com/DEFRA/waste-exemptions-back-office/pull/1402) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `d695b36` to `23bf381` [\#1401](https://github.com/DEFRA/waste-exemptions-back-office/pull/1401) ([dependabot[bot]](https://github.com/apps/dependabot))
- Feature/ruby 3207 export users roles [\#1399](https://github.com/DEFRA/waste-exemptions-back-office/pull/1399) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Feature/ruby 3207 export users roles [\#1398](https://github.com/DEFRA/waste-exemptions-back-office/pull/1398) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump waste\_exemptions\_engine from `a758324` to `d695b36` [\#1397](https://github.com/DEFRA/waste-exemptions-back-office/pull/1397) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `adce297` to `a758324` [\#1395](https://github.com/DEFRA/waste-exemptions-back-office/pull/1395) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rspec from 3.0.1 to 3.0.2 [\#1394](https://github.com/DEFRA/waste-exemptions-back-office/pull/1394) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rspec-rails from 6.1.2 to 6.1.3 [\#1393](https://github.com/DEFRA/waste-exemptions-back-office/pull/1393) ([dependabot[bot]](https://github.com/apps/dependabot))
- \[RUBY-3126\] Update Gemfile.lock with latest waste\_exemptions\_engine and mime-types-data versions [\#1387](https://github.com/DEFRA/waste-exemptions-back-office/pull/1387) ([jjromeo](https://github.com/jjromeo))
- \[RUBY-3155\] Update Gemfile.lock to latest waste\_exemptions\_engine revision [\#1385](https://github.com/DEFRA/waste-exemptions-back-office/pull/1385) ([brujeo](https://github.com/brujeo))
- \[RUBY-3189\] Update Gemfile.lock to latest waste\_exemptions\_engine revision [\#1384](https://github.com/DEFRA/waste-exemptions-back-office/pull/1384) ([jjromeo](https://github.com/jjromeo))
- Chore/ruby 3188 private repos [\#1383](https://github.com/DEFRA/waste-exemptions-back-office/pull/1383) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump waste\_exemptions\_engine from `f0e709f` to `9c9083d` [\#1381](https://github.com/DEFRA/waste-exemptions-back-office/pull/1381) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `8f7d694` to `f0e709f` [\#1377](https://github.com/DEFRA/waste-exemptions-back-office/pull/1377) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `33a2677` to `8f7d694` [\#1376](https://github.com/DEFRA/waste-exemptions-back-office/pull/1376) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `b0c5f2e` to `33a2677` [\#1375](https://github.com/DEFRA/waste-exemptions-back-office/pull/1375) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `bf9f6e9` to `b0c5f2e` [\#1374](https://github.com/DEFRA/waste-exemptions-back-office/pull/1374) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `0d5a77e` to `bf9f6e9` [\#1373](https://github.com/DEFRA/waste-exemptions-back-office/pull/1373) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump net-imap from 0.4.11 to 0.4.12 [\#1367](https://github.com/DEFRA/waste-exemptions-back-office/pull/1367) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump timecop from 0.9.8 to 0.9.9 [\#1366](https://github.com/DEFRA/waste-exemptions-back-office/pull/1366) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump faker from 3.3.1 to 3.4.1 [\#1359](https://github.com/DEFRA/waste-exemptions-back-office/pull/1359) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump cancancan from 3.5.0 to 3.6.1 [\#1356](https://github.com/DEFRA/waste-exemptions-back-office/pull/1356) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump notifications-ruby-client from 6.0.0 to 6.1.0 [\#1347](https://github.com/DEFRA/waste-exemptions-back-office/pull/1347) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump passenger from 6.0.20 to 6.0.22 [\#1346](https://github.com/DEFRA/waste-exemptions-back-office/pull/1346) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rails from 2.24.1 to 2.25.0 [\#1344](https://github.com/DEFRA/waste-exemptions-back-office/pull/1344) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump govuk\_design\_system\_formbuilder from 5.3.3 to 5.4.0 [\#1342](https://github.com/DEFRA/waste-exemptions-back-office/pull/1342) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.13.1](https://github.com/defra/waste-exemptions-back-office/tree/v2.13.1) (2024-06-10)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.13.0...v2.13.1)

**Implemented enhancements:**

- \[RUBY-3013\] improving output of one\_off:undefined\_area\_fix task [\#1361](https://github.com/DEFRA/waste-exemptions-back-office/pull/1361) ([brujeo](https://github.com/brujeo))
- \[RUBY-3013\] feat: Add rake task to fix undefined areas for manually added site addresses [\#1360](https://github.com/DEFRA/waste-exemptions-back-office/pull/1360) ([brujeo](https://github.com/brujeo))

**Merged pull requests:**

- Update CHANGELOG [\#1369](https://github.com/DEFRA/waste-exemptions-back-office/pull/1369) ([brujeo](https://github.com/brujeo))
- Bump waste\_exemptions\_engine from `1543be3` to `0d5a77e` [\#1365](https://github.com/DEFRA/waste-exemptions-back-office/pull/1365) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump actionpack from 7.1.3.3 to 7.1.3.4 [\#1364](https://github.com/DEFRA/waste-exemptions-back-office/pull/1364) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump actiontext from 7.1.3.3 to 7.1.3.4 [\#1363](https://github.com/DEFRA/waste-exemptions-back-office/pull/1363) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump webmock from 3.23.0 to 3.23.1 [\#1353](https://github.com/DEFRA/waste-exemptions-back-office/pull/1353) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.13.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.13.0) (2024-05-29)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.12.0...v2.13.0)

**Implemented enhancements:**

- \[RUBY-3153\] Use monetary text input for charge management + update page headers and titles [\#1348](https://github.com/DEFRA/waste-exemptions-back-office/pull/1348) ([brujeo](https://github.com/brujeo))
- Feature/3050 hide add band link when limit reached [\#1331](https://github.com/DEFRA/waste-exemptions-back-office/pull/1331) ([brujeo](https://github.com/brujeo))
- RUBY 3066 wex charging bo charging catalogue management rebased [\#1329](https://github.com/DEFRA/waste-exemptions-back-office/pull/1329) ([jjromeo](https://github.com/jjromeo))
- RUBY 3065 wex charging bo band charges deletion [\#1328](https://github.com/DEFRA/waste-exemptions-back-office/pull/1328) ([jjromeo](https://github.com/jjromeo))
- RUBY-3050: WEX Charging: Band and charge management [\#1314](https://github.com/DEFRA/waste-exemptions-back-office/pull/1314) ([brujeo](https://github.com/brujeo))
- \[RUBY-2749\] Add deregistration details page, and enhance styles [\#1313](https://github.com/DEFRA/waste-exemptions-back-office/pull/1313) ([jjromeo](https://github.com/jjromeo))

**Fixed bugs:**

- \[RUBY-3153\] adjusting page title for charge edit page [\#1350](https://github.com/DEFRA/waste-exemptions-back-office/pull/1350) ([brujeo](https://github.com/brujeo))
- RUBY 3066 wex charging bo charging catalogue management rebased [\#1339](https://github.com/DEFRA/waste-exemptions-back-office/pull/1339) ([jjromeo](https://github.com/jjromeo))
- \[RUBY-3066\] Refactor html to allow fixing accessibility issues and slightly improve layout [\#1338](https://github.com/DEFRA/waste-exemptions-back-office/pull/1338) ([jjromeo](https://github.com/jjromeo))
- Ruby 2749 wex bo add deregistration details to a registration [\#1322](https://github.com/DEFRA/waste-exemptions-back-office/pull/1322) ([jjromeo](https://github.com/jjromeo))

**Merged pull requests:**

- Update CHANGELOG [\#1357](https://github.com/DEFRA/waste-exemptions-back-office/pull/1357) ([jjromeo](https://github.com/jjromeo))
- Bump waste\_exemptions\_engine from `82be2f5` to `1543be3` [\#1355](https://github.com/DEFRA/waste-exemptions-back-office/pull/1355) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `95551b4` to `82be2f5` [\#1354](https://github.com/DEFRA/waste-exemptions-back-office/pull/1354) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `82ad929` to `95551b4` [\#1352](https://github.com/DEFRA/waste-exemptions-back-office/pull/1352) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `f8df377` to `82ad929` [\#1349](https://github.com/DEFRA/waste-exemptions-back-office/pull/1349) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `e5037f4` to `f8df377` [\#1340](https://github.com/DEFRA/waste-exemptions-back-office/pull/1340) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `6376c9f` to `2c21243` [\#1334](https://github.com/DEFRA/waste-exemptions-back-office/pull/1334) ([dependabot[bot]](https://github.com/apps/dependabot))
- Removing unused param [\#1332](https://github.com/DEFRA/waste-exemptions-back-office/pull/1332) ([brujeo](https://github.com/brujeo))
- rake task to load custom seed file [\#1326](https://github.com/DEFRA/waste-exemptions-back-office/pull/1326) ([brujeo](https://github.com/brujeo))

## [v2.12.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.12.0) (2024-04-29)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.11.0...v2.12.0)

**Implemented enhancements:**

- \[RUBY-2976\] Add unsubscribe functionality for renewal emails [\#1282](https://github.com/DEFRA/waste-exemptions-back-office/pull/1282) ([jjromeo](https://github.com/jjromeo))

**Fixed bugs:**

- \[RUBY-2916\] Add error handling for missing contact email when resending edit invite [\#1305](https://github.com/DEFRA/waste-exemptions-back-office/pull/1305) ([jjromeo](https://github.com/jjromeo))
- \[RUBY-2916\] Add error handling for missing contact email in SendEditInviteEmailsController [\#1303](https://github.com/DEFRA/waste-exemptions-back-office/pull/1303) ([jjromeo](https://github.com/jjromeo))
- \[RUBY-2976\] Add skip\_opted\_out\_check option to renewal email service to bypass opt-in check [\#1301](https://github.com/DEFRA/waste-exemptions-back-office/pull/1301) ([jjromeo](https://github.com/jjromeo))
- \[RUBY-3041\] rake task to fix user journeys incorrectly marked as incomplete [\#1299](https://github.com/DEFRA/waste-exemptions-back-office/pull/1299) ([brujeo](https://github.com/brujeo))
- Ruby 2976 wex add unsubscribe functionality to the renewal reminder emails in wex [\#1298](https://github.com/DEFRA/waste-exemptions-back-office/pull/1298) ([jjromeo](https://github.com/jjromeo))
- RUBY-2954 fix incorrect template name for first renewal email reminder in comms history [\#1292](https://github.com/DEFRA/waste-exemptions-back-office/pull/1292) ([brujeo](https://github.com/brujeo))
- RUBY 2976 wex add unsubscribe functionality to the renewal reminder emails in wex [\#1285](https://github.com/DEFRA/waste-exemptions-back-office/pull/1285) ([jjromeo](https://github.com/jjromeo))

**Merged pull requests:**

- Update CHANGELOG [\#1311](https://github.com/DEFRA/waste-exemptions-back-office/pull/1311) ([jjromeo](https://github.com/jjromeo))
- Chore/rails 7 1 [\#1309](https://github.com/DEFRA/waste-exemptions-back-office/pull/1309) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Chore/rails 7 1 [\#1308](https://github.com/DEFRA/waste-exemptions-back-office/pull/1308) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Chore/rails 7 1 [\#1307](https://github.com/DEFRA/waste-exemptions-back-office/pull/1307) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump waste\_exemptions\_engine from `6b56de7` to `de65e8c` [\#1306](https://github.com/DEFRA/waste-exemptions-back-office/pull/1306) ([dependabot[bot]](https://github.com/apps/dependabot))
- Chore/rails 7 1 [\#1302](https://github.com/DEFRA/waste-exemptions-back-office/pull/1302) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump devise from 4.9.3 to 4.9.4 [\#1295](https://github.com/DEFRA/waste-exemptions-back-office/pull/1295) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `7b5b747` to `9443650` [\#1294](https://github.com/DEFRA/waste-exemptions-back-office/pull/1294) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rspec from 2.26.1 to 2.29.1 [\#1293](https://github.com/DEFRA/waste-exemptions-back-office/pull/1293) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `223bdcc` to `7b5b747` [\#1288](https://github.com/DEFRA/waste-exemptions-back-office/pull/1288) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rails from 2.24.0 to 2.24.1 [\#1283](https://github.com/DEFRA/waste-exemptions-back-office/pull/1283) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rspec-rails from 6.1.1 to 6.1.2 [\#1281](https://github.com/DEFRA/waste-exemptions-back-office/pull/1281) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump pg from 1.5.4 to 1.5.6 [\#1270](https://github.com/DEFRA/waste-exemptions-back-office/pull/1270) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump wicked\_pdf from 2.7.0 to 2.8.0 [\#1265](https://github.com/DEFRA/waste-exemptions-back-office/pull/1265) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump webmock from 3.19.1 to 3.23.0 [\#1263](https://github.com/DEFRA/waste-exemptions-back-office/pull/1263) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump net-imap from 0.4.9.1 to 0.4.10 [\#1248](https://github.com/DEFRA/waste-exemptions-back-office/pull/1248) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump capybara from 3.39.2 to 3.40.0 [\#1245](https://github.com/DEFRA/waste-exemptions-back-office/pull/1245) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.11.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.11.0) (2024-03-18)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.10.0...v2.11.0)

**Merged pull requests:**

- Update CHANGELOG [\#1279](https://github.com/DEFRA/waste-exemptions-back-office/pull/1279) ([jjromeo](https://github.com/jjromeo))
- Bump waste\_exemptions\_engine from `5976f8c` to `b59b6f0` [\#1277](https://github.com/DEFRA/waste-exemptions-back-office/pull/1277) ([dependabot[bot]](https://github.com/apps/dependabot))
- \[RUBY-2885\] Add analytics feature for user journey data [\#1275](https://github.com/DEFRA/waste-exemptions-back-office/pull/1275) ([jjromeo](https://github.com/jjromeo))
- Release v2.10.1 [\#1274](https://github.com/DEFRA/waste-exemptions-back-office/pull/1274) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump defra\_ruby\_template from 3.15.0 to 3.15.1 [\#1273](https://github.com/DEFRA/waste-exemptions-back-office/pull/1273) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rails from 2.23.1 to 2.24.0 [\#1272](https://github.com/DEFRA/waste-exemptions-back-office/pull/1272) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `4a07d71` to `910b352` [\#1268](https://github.com/DEFRA/waste-exemptions-back-office/pull/1268) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rack from 2.2.8 to 2.2.8.1 [\#1266](https://github.com/DEFRA/waste-exemptions-back-office/pull/1266) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rails from 7.0.8 to 7.0.8.1 [\#1262](https://github.com/DEFRA/waste-exemptions-back-office/pull/1262) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump govuk\_design\_system\_formbuilder from 5.0.0 to 5.2.0 [\#1261](https://github.com/DEFRA/waste-exemptions-back-office/pull/1261) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump defra\_ruby\_template from 3.13.0 to 3.15.0 [\#1259](https://github.com/DEFRA/waste-exemptions-back-office/pull/1259) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.10.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.10.0) (2024-02-07)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.9.1...v2.10.0)

**Implemented enhancements:**

- \[RUBY-2829\] persisting search terms in url [\#1227](https://github.com/DEFRA/waste-exemptions-back-office/pull/1227) ([brujeo](https://github.com/brujeo))

**Fixed bugs:**

- Add one-off rake task to fix communication\_log data anomalies [\#1243](https://github.com/DEFRA/waste-exemptions-back-office/pull/1243) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

**Merged pull requests:**

- Update CHANGELOG [\#1251](https://github.com/DEFRA/waste-exemptions-back-office/pull/1251) ([jjromeo](https://github.com/jjromeo))
- Bump waste\_exemptions\_engine from `601410f` to `4a07d71` [\#1247](https://github.com/DEFRA/waste-exemptions-back-office/pull/1247) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `68a51b8` to `601410f` [\#1244](https://github.com/DEFRA/waste-exemptions-back-office/pull/1244) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `3645aab` to `04dc6f6` [\#1241](https://github.com/DEFRA/waste-exemptions-back-office/pull/1241) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rspec-rails from 6.1.0 to 6.1.1 [\#1240](https://github.com/DEFRA/waste-exemptions-back-office/pull/1240) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump bullet from 7.1.5 to 7.1.6 [\#1239](https://github.com/DEFRA/waste-exemptions-back-office/pull/1239) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump faker from 3.2.2 to 3.2.3 [\#1237](https://github.com/DEFRA/waste-exemptions-back-office/pull/1237) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `95f1ded` to `3645aab` [\#1236](https://github.com/DEFRA/waste-exemptions-back-office/pull/1236) ([dependabot[bot]](https://github.com/apps/dependabot))
- updating dependencies + coding style fixes [\#1235](https://github.com/DEFRA/waste-exemptions-back-office/pull/1235) ([brujeo](https://github.com/brujeo))
- Bump waste\_exemptions\_engine from `694bc37` to `95f1ded` [\#1234](https://github.com/DEFRA/waste-exemptions-back-office/pull/1234) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump net-imap from 0.4.9 to 0.4.9.1 [\#1233](https://github.com/DEFRA/waste-exemptions-back-office/pull/1233) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump bullet from 7.1.4 to 7.1.5 [\#1232](https://github.com/DEFRA/waste-exemptions-back-office/pull/1232) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump net-smtp from 0.4.0 to 0.4.0.1 [\#1230](https://github.com/DEFRA/waste-exemptions-back-office/pull/1230) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump factory\_bot\_rails from 6.4.2 to 6.4.3 [\#1228](https://github.com/DEFRA/waste-exemptions-back-office/pull/1228) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `dafb546` to `0dfcf57` [\#1223](https://github.com/DEFRA/waste-exemptions-back-office/pull/1223) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump net-imap from 0.4.7 to 0.4.8 [\#1221](https://github.com/DEFRA/waste-exemptions-back-office/pull/1221) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump govuk\_design\_system\_formbuilder from 4.1.1 to 5.0.0 [\#1220](https://github.com/DEFRA/waste-exemptions-back-office/pull/1220) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump sucker\_punch from 3.1.0 to 3.2.0 [\#1219](https://github.com/DEFRA/waste-exemptions-back-office/pull/1219) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.9.1](https://github.com/defra/waste-exemptions-back-office/tree/v2.9.1) (2023-12-07)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.9.0...v2.9.1)

**Implemented enhancements:**

- \[RUBY-2786\] Fix site\_ngr method to return nil for registrations with site address [\#1216](https://github.com/DEFRA/waste-exemptions-back-office/pull/1216) ([jjromeo](https://github.com/jjromeo))

**Merged pull requests:**

- Version 2.9.1 [\#1217](https://github.com/DEFRA/waste-exemptions-back-office/pull/1217) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump waste\_exemptions\_engine from `86ca75c` to `dafb546` [\#1215](https://github.com/DEFRA/waste-exemptions-back-office/pull/1215) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump net-imap from 0.4.6 to 0.4.7 [\#1214](https://github.com/DEFRA/waste-exemptions-back-office/pull/1214) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `2bf2e85` to `86ca75c` [\#1213](https://github.com/DEFRA/waste-exemptions-back-office/pull/1213) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `8d83d6f` to `2bf2e85` [\#1212](https://github.com/DEFRA/waste-exemptions-back-office/pull/1212) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `81856b1` to `3ae21e7` [\#1211](https://github.com/DEFRA/waste-exemptions-back-office/pull/1211) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump factory\_bot\_rails from 6.2.0 to 6.4.2 [\#1210](https://github.com/DEFRA/waste-exemptions-back-office/pull/1210) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump net-imap from 0.4.5 to 0.4.6 [\#1209](https://github.com/DEFRA/waste-exemptions-back-office/pull/1209) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump spring from 4.1.2 to 4.1.3 [\#1208](https://github.com/DEFRA/waste-exemptions-back-office/pull/1208) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rspec-rails from 6.0.3 to 6.1.0 [\#1207](https://github.com/DEFRA/waste-exemptions-back-office/pull/1207) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `3115fc5` to `81856b1` [\#1206](https://github.com/DEFRA/waste-exemptions-back-office/pull/1206) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rails from 2.22.1 to 2.22.2 [\#1204](https://github.com/DEFRA/waste-exemptions-back-office/pull/1204) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump bullet from 7.1.3 to 7.1.4 [\#1203](https://github.com/DEFRA/waste-exemptions-back-office/pull/1203) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `285d470` to `3115fc5` [\#1202](https://github.com/DEFRA/waste-exemptions-back-office/pull/1202) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump spring from 4.1.1 to 4.1.2 [\#1199](https://github.com/DEFRA/waste-exemptions-back-office/pull/1199) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump net-imap from 0.4.2 to 0.4.5 [\#1197](https://github.com/DEFRA/waste-exemptions-back-office/pull/1197) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rails from 2.21.2 to 2.22.1 [\#1184](https://github.com/DEFRA/waste-exemptions-back-office/pull/1184) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump devise\_invitable from 2.0.8 to 2.0.9 [\#1183](https://github.com/DEFRA/waste-exemptions-back-office/pull/1183) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rspec from 2.24.1 to 2.25.0 [\#1182](https://github.com/DEFRA/waste-exemptions-back-office/pull/1182) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.9.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.9.0) (2023-11-13)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.8.0...v2.9.0)

**Implemented enhancements:**

- RUBY 2789 wex transient registrations clean up task performance issue [\#1194](https://github.com/DEFRA/waste-exemptions-back-office/pull/1194) ([jjromeo](https://github.com/jjromeo))
- RUBY 2742 wex bo add reset transient registration action to registrations [\#1180](https://github.com/DEFRA/waste-exemptions-back-office/pull/1180) ([jjromeo](https://github.com/jjromeo))
- Rake task to rename site\_address areas [\#1168](https://github.com/DEFRA/waste-exemptions-back-office/pull/1168) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

**Fixed bugs:**

- RUBY 2742 wex bo add reset transient registration action to registrations [\#1188](https://github.com/DEFRA/waste-exemptions-back-office/pull/1188) ([jjromeo](https://github.com/jjromeo))
- RUBY 2742 wex bo add reset transient registration action to registrations [\#1186](https://github.com/DEFRA/waste-exemptions-back-office/pull/1186) ([jjromeo](https://github.com/jjromeo))

**Merged pull requests:**

- Update CHANGELOG [\#1196](https://github.com/DEFRA/waste-exemptions-back-office/pull/1196) ([jjromeo](https://github.com/jjromeo))
- Transient registration cleanup schedule update [\#1195](https://github.com/DEFRA/waste-exemptions-back-office/pull/1195) ([timstone](https://github.com/timstone))
- Bump bullet from 7.1.2 to 7.1.3 [\#1191](https://github.com/DEFRA/waste-exemptions-back-office/pull/1191) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump faker from 3.2.1 to 3.2.2 [\#1189](https://github.com/DEFRA/waste-exemptions-back-office/pull/1189) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump paper\_trail from 15.0.0 to 15.1.0 [\#1179](https://github.com/DEFRA/waste-exemptions-back-office/pull/1179) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `b56589a` to `13bed43` [\#1178](https://github.com/DEFRA/waste-exemptions-back-office/pull/1178) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump net-imap from 0.4.1 to 0.4.2 [\#1177](https://github.com/DEFRA/waste-exemptions-back-office/pull/1177) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `e9d2070` to `b56589a` [\#1176](https://github.com/DEFRA/waste-exemptions-back-office/pull/1176) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `47d2315` to `e9d2070` [\#1175](https://github.com/DEFRA/waste-exemptions-back-office/pull/1175) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump bullet from 7.0.7 to 7.1.2 [\#1173](https://github.com/DEFRA/waste-exemptions-back-office/pull/1173) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `de32efa` to `47d2315` [\#1172](https://github.com/DEFRA/waste-exemptions-back-office/pull/1172) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump pgreset from 0.3 to 0.4 [\#1171](https://github.com/DEFRA/waste-exemptions-back-office/pull/1171) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump devise from 4.9.2 to 4.9.3 [\#1169](https://github.com/DEFRA/waste-exemptions-back-office/pull/1169) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `a3dce00` to `de32efa` [\#1167](https://github.com/DEFRA/waste-exemptions-back-office/pull/1167) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.8.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.8.0) (2023-10-09)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.7.4...v2.8.0)

**Implemented enhancements:**

- Fix/self serve edit issues [\#1148](https://github.com/DEFRA/waste-exemptions-back-office/pull/1148) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Feature/ruby 2641 wex communication history showing in back office [\#1126](https://github.com/DEFRA/waste-exemptions-back-office/pull/1126) ([brujeo](https://github.com/brujeo))
- \[RUBY-2508\] Change notify template for Send deregistration  invite email [\#1121](https://github.com/DEFRA/waste-exemptions-back-office/pull/1121) ([jjromeo](https://github.com/jjromeo))

**Fixed bugs:**

- Fix/ruby 2481 comms history [\#1154](https://github.com/DEFRA/waste-exemptions-back-office/pull/1154) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Fix typo in I18n key [\#1140](https://github.com/DEFRA/waste-exemptions-back-office/pull/1140) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

**Merged pull requests:**

- Update CHANGELOG [\#1162](https://github.com/DEFRA/waste-exemptions-back-office/pull/1162) ([brujeo](https://github.com/brujeo))
- Bump waste\_exemptions\_engine from `bcd04ab` to `a3dce00` [\#1161](https://github.com/DEFRA/waste-exemptions-back-office/pull/1161) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `9222355` to `bcd04ab` [\#1157](https://github.com/DEFRA/waste-exemptions-back-office/pull/1157) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rails from 2.21.1 to 2.21.2 [\#1156](https://github.com/DEFRA/waste-exemptions-back-office/pull/1156) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `5fcdee1` to `9222355` [\#1155](https://github.com/DEFRA/waste-exemptions-back-office/pull/1155) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `53c74c0` to `5fcdee1` [\#1153](https://github.com/DEFRA/waste-exemptions-back-office/pull/1153) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `afd62cc` to `53c74c0` [\#1152](https://github.com/DEFRA/waste-exemptions-back-office/pull/1152) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `e62cbe0` to `afd62cc` [\#1150](https://github.com/DEFRA/waste-exemptions-back-office/pull/1150) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rspec from 2.23.2 to 2.24.1 [\#1149](https://github.com/DEFRA/waste-exemptions-back-office/pull/1149) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump net-smtp from 0.3.3 to 0.4.0 [\#1147](https://github.com/DEFRA/waste-exemptions-back-office/pull/1147) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `761e6dd` to `e62cbe0` [\#1145](https://github.com/DEFRA/waste-exemptions-back-office/pull/1145) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `c640d09` to `761e6dd` [\#1144](https://github.com/DEFRA/waste-exemptions-back-office/pull/1144) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rails from 7.0.7.2 to 7.0.8 [\#1142](https://github.com/DEFRA/waste-exemptions-back-office/pull/1142) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump web-console from 4.2.0 to 4.2.1 [\#1139](https://github.com/DEFRA/waste-exemptions-back-office/pull/1139) ([dependabot[bot]](https://github.com/apps/dependabot))
- Feature/edit forms [\#1138](https://github.com/DEFRA/waste-exemptions-back-office/pull/1138) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump pg from 1.5.3 to 1.5.4 [\#1137](https://github.com/DEFRA/waste-exemptions-back-office/pull/1137) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `4c8d8a2` to `34b0055` [\#1136](https://github.com/DEFRA/waste-exemptions-back-office/pull/1136) ([dependabot[bot]](https://github.com/apps/dependabot))
- Feature/edit forms [\#1131](https://github.com/DEFRA/waste-exemptions-back-office/pull/1131) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump webmock from 3.18.1 to 3.19.1 [\#1130](https://github.com/DEFRA/waste-exemptions-back-office/pull/1130) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump wicked\_pdf from 2.6.3 to 2.7.0 [\#1128](https://github.com/DEFRA/waste-exemptions-back-office/pull/1128) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rails from 7.0.6 to 7.0.7.2 [\#1127](https://github.com/DEFRA/waste-exemptions-back-office/pull/1127) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump net-imap from 0.3.6 to 0.3.7 [\#1116](https://github.com/DEFRA/waste-exemptions-back-office/pull/1116) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump govuk\_design\_system\_formbuilder from 4.0.0 to 4.1.1 [\#1115](https://github.com/DEFRA/waste-exemptions-back-office/pull/1115) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.7.4](https://github.com/defra/waste-exemptions-back-office/tree/v2.7.4) (2023-07-12)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.7.3...v2.7.4)

**Implemented enhancements:**

- Feature/ruby 2321 cease t27 task [\#1104](https://github.com/DEFRA/waste-exemptions-back-office/pull/1104) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- rake task to cease registration exemptions [\#1102](https://github.com/DEFRA/waste-exemptions-back-office/pull/1102) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Feature/ruby 2841 comms history [\#1092](https://github.com/DEFRA/waste-exemptions-back-office/pull/1092) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Feature/ruby 2455 wex notify text messaging renewal reminder texts [\#1089](https://github.com/DEFRA/waste-exemptions-back-office/pull/1089) ([brujeo](https://github.com/brujeo))
- Feature/ruby 2514 edit expiry date [\#1084](https://github.com/DEFRA/waste-exemptions-back-office/pull/1084) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- feature/RUBY 2330 wex back office view registration certificate [\#1075](https://github.com/DEFRA/waste-exemptions-back-office/pull/1075) ([jjromeo](https://github.com/jjromeo))

**Fixed bugs:**

- Run migration and update schema.rb [\#1111](https://github.com/DEFRA/waste-exemptions-back-office/pull/1111) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- fix/action\_links [\#1088](https://github.com/DEFRA/waste-exemptions-back-office/pull/1088) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Fix/action links helper [\#1087](https://github.com/DEFRA/waste-exemptions-back-office/pull/1087) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- RUBY-2087: sanitizing search terms [\#1083](https://github.com/DEFRA/waste-exemptions-back-office/pull/1083) ([brujeo](https://github.com/brujeo))

**Merged pull requests:**

- Release v2.7.4 [\#1110](https://github.com/DEFRA/waste-exemptions-back-office/pull/1110) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump waste\_exemptions\_engine from `d069eb6` to `540af98` [\#1109](https://github.com/DEFRA/waste-exemptions-back-office/pull/1109) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `05335be` to `d069eb6` [\#1108](https://github.com/DEFRA/waste-exemptions-back-office/pull/1108) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `c2a5e04` to `05335be` [\#1107](https://github.com/DEFRA/waste-exemptions-back-office/pull/1107) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `19cda07` to `c2a5e04` [\#1105](https://github.com/DEFRA/waste-exemptions-back-office/pull/1105) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `f1c22d9` to `19cda07` [\#1101](https://github.com/DEFRA/waste-exemptions-back-office/pull/1101) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `94b1036` to `f1c22d9` [\#1100](https://github.com/DEFRA/waste-exemptions-back-office/pull/1100) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rails from 7.0.5.1 to 7.0.6 [\#1099](https://github.com/DEFRA/waste-exemptions-back-office/pull/1099) ([dependabot[bot]](https://github.com/apps/dependabot))
- Update CHANGELOG [\#1095](https://github.com/DEFRA/waste-exemptions-back-office/pull/1095) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump waste\_exemptions\_engine from `87de26e` to `eb704bf` [\#1081](https://github.com/DEFRA/waste-exemptions-back-office/pull/1081) ([dependabot[bot]](https://github.com/apps/dependabot))
- Modify uglifier instantiation to support ES6 [\#1080](https://github.com/DEFRA/waste-exemptions-back-office/pull/1080) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Upgrade to Rails 7 [\#1079](https://github.com/DEFRA/waste-exemptions-back-office/pull/1079) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

## [v2.7.3](https://github.com/defra/waste-exemptions-back-office/tree/v2.7.3) (2023-05-26)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.7.2...v2.7.3)

**Merged pull requests:**

- Update CHANGELOG [\#1074](https://github.com/DEFRA/waste-exemptions-back-office/pull/1074) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump waste\_exemptions\_engine from `05a3aaa` to `e55e06c` [\#1073](https://github.com/DEFRA/waste-exemptions-back-office/pull/1073) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `d1139eb` to `05a3aaa` [\#1072](https://github.com/DEFRA/waste-exemptions-back-office/pull/1072) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `8a1e9f8` to `d1139eb` [\#1071](https://github.com/DEFRA/waste-exemptions-back-office/pull/1071) ([dependabot[bot]](https://github.com/apps/dependabot))
- Feature/ruby 2064 wex replace send grid with notify for devise emails user invites password resets etc [\#1070](https://github.com/DEFRA/waste-exemptions-back-office/pull/1070) ([brujeo](https://github.com/brujeo))
- Bump waste\_exemptions\_engine from `0f1a937` to `8a1e9f8` [\#1069](https://github.com/DEFRA/waste-exemptions-back-office/pull/1069) ([dependabot[bot]](https://github.com/apps/dependabot))
- Change production log level to :info [\#1068](https://github.com/DEFRA/waste-exemptions-back-office/pull/1068) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump waste\_exemptions\_engine from `56bb3cf` to `0f1a937` [\#1067](https://github.com/DEFRA/waste-exemptions-back-office/pull/1067) ([dependabot[bot]](https://github.com/apps/dependabot))
- Update CHANGELOG.md [\#1066](https://github.com/DEFRA/waste-exemptions-back-office/pull/1066) ([brujeo](https://github.com/brujeo))
- Bump pg from 1.4.6 to 1.5.3 [\#1058](https://github.com/DEFRA/waste-exemptions-back-office/pull/1058) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.7.2](https://github.com/defra/waste-exemptions-back-office/tree/v2.7.2) (2023-05-16)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.7.1...v2.7.2)

**Fixed bugs:**

- Fix/resend dereg link [\#1051](https://github.com/DEFRA/waste-exemptions-back-office/pull/1051) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

**Merged pull requests:**

- Update CHANGELOG [\#1064](https://github.com/DEFRA/waste-exemptions-back-office/pull/1064) ([brujeo](https://github.com/brujeo))
- Bump waste\_exemptions\_engine from `f736355` to `56bb3cf` [\#1063](https://github.com/DEFRA/waste-exemptions-back-office/pull/1063) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `00475d0` to `f736355` [\#1060](https://github.com/DEFRA/waste-exemptions-back-office/pull/1060) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `3555d1c` to `00475d0` [\#1052](https://github.com/DEFRA/waste-exemptions-back-office/pull/1052) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump nokogiri from 1.14.2 to 1.14.3 [\#1047](https://github.com/DEFRA/waste-exemptions-back-office/pull/1047) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rails from 2.18.0 to 2.19.0 [\#1046](https://github.com/DEFRA/waste-exemptions-back-office/pull/1046) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `af94cbc` to `3555d1c` [\#1045](https://github.com/DEFRA/waste-exemptions-back-office/pull/1045) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump devise from 4.9.0 to 4.9.2 [\#1044](https://github.com/DEFRA/waste-exemptions-back-office/pull/1044) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `35173aa` to `af94cbc` [\#1039](https://github.com/DEFRA/waste-exemptions-back-office/pull/1039) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `8e7564a` to `35173aa` [\#1038](https://github.com/DEFRA/waste-exemptions-back-office/pull/1038) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `9c9e717` to `8e7564a` [\#1037](https://github.com/DEFRA/waste-exemptions-back-office/pull/1037) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rails from 6.1.7.2 to 6.1.7.3 [\#1034](https://github.com/DEFRA/waste-exemptions-back-office/pull/1034) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump database\_cleaner from 2.0.1 to 2.0.2 [\#1033](https://github.com/DEFRA/waste-exemptions-back-office/pull/1033) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump cancancan from 3.4.0 to 3.5.0 [\#1025](https://github.com/DEFRA/waste-exemptions-back-office/pull/1025) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rails from 2.17.4 to 2.18.0 [\#1021](https://github.com/DEFRA/waste-exemptions-back-office/pull/1021) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump pg from 1.4.5 to 1.4.6 [\#1020](https://github.com/DEFRA/waste-exemptions-back-office/pull/1020) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump paper\_trail from 13.0.0 to 14.0.0 [\#964](https://github.com/DEFRA/waste-exemptions-back-office/pull/964) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.7.1](https://github.com/defra/waste-exemptions-back-office/tree/v2.7.1) (2023-03-15)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.7.0...v2.7.1)

**Implemented enhancements:**

- Move resend deregistration email link [\#1031](https://github.com/DEFRA/waste-exemptions-back-office/pull/1031) ([endofunky](https://github.com/endofunky))
- Add resend deregistration email link [\#1030](https://github.com/DEFRA/waste-exemptions-back-office/pull/1030) ([endofunky](https://github.com/endofunky))

**Merged pull requests:**

- Update CHANGELOG [\#1036](https://github.com/DEFRA/waste-exemptions-back-office/pull/1036) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump waste\_exemptions\_engine from `d624ded` to `9c9e717` [\#1035](https://github.com/DEFRA/waste-exemptions-back-office/pull/1035) ([dependabot[bot]](https://github.com/apps/dependabot))
- Updating companies house number in factory [\#1032](https://github.com/DEFRA/waste-exemptions-back-office/pull/1032) ([timstone](https://github.com/timstone))

## [v2.7.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.7.0) (2023-03-07)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.6.2...v2.7.0)

**Implemented enhancements:**

- Add rake task to export deregistration email CSV [\#1027](https://github.com/DEFRA/waste-exemptions-back-office/pull/1027) ([endofunky](https://github.com/endofunky))
- Add deregistration email CSV export [\#1022](https://github.com/DEFRA/waste-exemptions-back-office/pull/1022) ([endofunky](https://github.com/endofunky))
- Vary the testing exemptions [\#1018](https://github.com/DEFRA/waste-exemptions-back-office/pull/1018) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Avoid creating exemptions in test helper [\#1015](https://github.com/DEFRA/waste-exemptions-back-office/pull/1015) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Create new registration test helper [\#1014](https://github.com/DEFRA/waste-exemptions-back-office/pull/1014) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Add deregistration email jobs [\#1012](https://github.com/DEFRA/waste-exemptions-back-office/pull/1012) ([endofunky](https://github.com/endofunky))
- create registration for testing [\#1011](https://github.com/DEFRA/waste-exemptions-back-office/pull/1011) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Show magic link [\#1008](https://github.com/DEFRA/waste-exemptions-back-office/pull/1008) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- defra stats access roles [\#1004](https://github.com/DEFRA/waste-exemptions-back-office/pull/1004) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Integrate edit exemptions form in RenewsController [\#999](https://github.com/DEFRA/waste-exemptions-back-office/pull/999) ([endofunky](https://github.com/endofunky))

**Fixed bugs:**

- Handle blank applicant/contact email for batch exports [\#1024](https://github.com/DEFRA/waste-exemptions-back-office/pull/1024) ([endofunky](https://github.com/endofunky))
- Fix return value and marking of sent emails on registrations [\#1023](https://github.com/DEFRA/waste-exemptions-back-office/pull/1023) ([endofunky](https://github.com/endofunky))
- Load factorybot gem in all environments [\#1017](https://github.com/DEFRA/waste-exemptions-back-office/pull/1017) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

**Merged pull requests:**

- Update CHANGELOG [\#1028](https://github.com/DEFRA/waste-exemptions-back-office/pull/1028) ([endofunky](https://github.com/endofunky))
- Bump waste\_exemptions\_engine from `4be1560` to `d624ded` [\#1019](https://github.com/DEFRA/waste-exemptions-back-office/pull/1019) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `6b66ebd` to `4be1560` [\#1016](https://github.com/DEFRA/waste-exemptions-back-office/pull/1016) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `8a3cfdd` to `dd9e038` [\#1013](https://github.com/DEFRA/waste-exemptions-back-office/pull/1013) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `9c5a41a` to `8a3cfdd` [\#1009](https://github.com/DEFRA/waste-exemptions-back-office/pull/1009) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `1974574` to `9c5a41a` [\#1007](https://github.com/DEFRA/waste-exemptions-back-office/pull/1007) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `72378b5` to `1974574` [\#1006](https://github.com/DEFRA/waste-exemptions-back-office/pull/1006) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `b7bb4e8` to `72378b5` [\#1003](https://github.com/DEFRA/waste-exemptions-back-office/pull/1003) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `36ee46d` to `279f10f` [\#998](https://github.com/DEFRA/waste-exemptions-back-office/pull/998) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rails from 6.1.7 to 6.1.7.2 [\#996](https://github.com/DEFRA/waste-exemptions-back-office/pull/996) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rack from 2.2.4 to 2.2.6.2 [\#993](https://github.com/DEFRA/waste-exemptions-back-office/pull/993) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste-exemptions-engine [\#989](https://github.com/DEFRA/waste-exemptions-back-office/pull/989) ([endofunky](https://github.com/endofunky))
- Bump spring from 4.1.0 to 4.1.1 [\#988](https://github.com/DEFRA/waste-exemptions-back-office/pull/988) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump devise\_invitable from 2.0.6 to 2.0.7 [\#987](https://github.com/DEFRA/waste-exemptions-back-office/pull/987) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump bullet from 7.0.4 to 7.0.7 [\#986](https://github.com/DEFRA/waste-exemptions-back-office/pull/986) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump faker from 3.0.0 to 3.1.0 [\#983](https://github.com/DEFRA/waste-exemptions-back-office/pull/983) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump net-imap from 0.3.2 to 0.3.4 [\#982](https://github.com/DEFRA/waste-exemptions-back-office/pull/982) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rails-html-sanitizer from 1.4.3 to 1.4.4 [\#978](https://github.com/DEFRA/waste-exemptions-back-office/pull/978) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump loofah from 2.19.0 to 2.19.1 [\#977](https://github.com/DEFRA/waste-exemptions-back-office/pull/977) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump net-imap from 0.3.1 to 0.3.2 [\#975](https://github.com/DEFRA/waste-exemptions-back-office/pull/975) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump nokogiri from 1.13.9 to 1.13.10 [\#974](https://github.com/DEFRA/waste-exemptions-back-office/pull/974) ([dependabot[bot]](https://github.com/apps/dependabot))
- Don't include deregistered\_at in RegistrationExemption versions [\#973](https://github.com/DEFRA/waste-exemptions-back-office/pull/973) ([endofunky](https://github.com/endofunky))
- Persist version on cease/revoke of registration exemptions [\#972](https://github.com/DEFRA/waste-exemptions-back-office/pull/972) ([endofunky](https://github.com/endofunky))
- Bump timecop from 0.9.5 to 0.9.6 [\#966](https://github.com/DEFRA/waste-exemptions-back-office/pull/966) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump bullet from 7.0.3 to 7.0.4 [\#965](https://github.com/DEFRA/waste-exemptions-back-office/pull/965) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rails from 2.17.2 to 2.17.3 [\#963](https://github.com/DEFRA/waste-exemptions-back-office/pull/963) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump govuk\_design\_system\_formbuilder from 3.1.2 to 3.3.0 [\#962](https://github.com/DEFRA/waste-exemptions-back-office/pull/962) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump pg from 1.4.4 to 1.4.5 [\#961](https://github.com/DEFRA/waste-exemptions-back-office/pull/961) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump jquery-rails from 4.5.0 to 4.5.1 [\#959](https://github.com/DEFRA/waste-exemptions-back-office/pull/959) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rspec from 2.14.2 to 2.15.0 [\#957](https://github.com/DEFRA/waste-exemptions-back-office/pull/957) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump faker from 2.23.0 to 3.0.0 [\#956](https://github.com/DEFRA/waste-exemptions-back-office/pull/956) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `7bb860f` to `d98fca0` [\#955](https://github.com/DEFRA/waste-exemptions-back-office/pull/955) ([dependabot[bot]](https://github.com/apps/dependabot))
- Release v2.6.2 [\#954](https://github.com/DEFRA/waste-exemptions-back-office/pull/954) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

## [v2.6.2](https://github.com/defra/waste-exemptions-back-office/tree/v2.6.2) (2022-11-01)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.6.1...v2.6.2)

**Implemented enhancements:**

- Add summary stats rake task [\#939](https://github.com/DEFRA/waste-exemptions-back-office/pull/939) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Track partial assisted digital [\#927](https://github.com/DEFRA/waste-exemptions-back-office/pull/927) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

**Fixed bugs:**

- summary stats fix [\#940](https://github.com/DEFRA/waste-exemptions-back-office/pull/940) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Add webrick gem for development environment [\#932](https://github.com/DEFRA/waste-exemptions-back-office/pull/932) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

**Merged pull requests:**

- Bump waste\_exemptions\_engine from `194e8e7` to `7bb860f` [\#953](https://github.com/DEFRA/waste-exemptions-back-office/pull/953) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump net-smtp from 0.3.2 to 0.3.3 [\#951](https://github.com/DEFRA/waste-exemptions-back-office/pull/951) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `d323a16` to `194e8e7` [\#950](https://github.com/DEFRA/waste-exemptions-back-office/pull/950) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rails from 2.16.1 to 2.17.2 [\#949](https://github.com/DEFRA/waste-exemptions-back-office/pull/949) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop-rspec from 2.14.1 to 2.14.2 [\#948](https://github.com/DEFRA/waste-exemptions-back-office/pull/948) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump secure\_headers from 6.4.0 to 6.5.0 [\#947](https://github.com/DEFRA/waste-exemptions-back-office/pull/947) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `a9cd028` to `d323a16` [\#946](https://github.com/DEFRA/waste-exemptions-back-office/pull/946) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop and rubocop gems [\#945](https://github.com/DEFRA/waste-exemptions-back-office/pull/945) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump nokogiri from 1.13.8 to 1.13.9 [\#938](https://github.com/DEFRA/waste-exemptions-back-office/pull/938) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rspec-rails from 6.0.0 to 6.0.1 [\#937](https://github.com/DEFRA/waste-exemptions-back-office/pull/937) ([dependabot[bot]](https://github.com/apps/dependabot))
- Enable recording user id by PaperTrail [\#935](https://github.com/DEFRA/waste-exemptions-back-office/pull/935) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump passenger from 5.3.7 to 6.0.15 [\#934](https://github.com/DEFRA/waste-exemptions-back-office/pull/934) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump simplecov from 0.17.1 to 0.21.2 [\#933](https://github.com/DEFRA/waste-exemptions-back-office/pull/933) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump pg from 1.4.3 to 1.4.4 [\#931](https://github.com/DEFRA/waste-exemptions-back-office/pull/931) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rspec-rails from 5.1.2 to 6.0.0 [\#930](https://github.com/DEFRA/waste-exemptions-back-office/pull/930) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump web-console from 2.3.0 to 4.2.0 [\#929](https://github.com/DEFRA/waste-exemptions-back-office/pull/929) ([dependabot[bot]](https://github.com/apps/dependabot))
- Upgrade to ruby3 [\#928](https://github.com/DEFRA/waste-exemptions-back-office/pull/928) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump spring from 4.0.0 to 4.1.0 [\#925](https://github.com/DEFRA/waste-exemptions-back-office/pull/925) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.6.1](https://github.com/defra/waste-exemptions-back-office/tree/v2.6.1) (2022-09-15)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.6.0...v2.6.1)

**Implemented enhancements:**

- Updating back office search hint text [\#921](https://github.com/DEFRA/waste-exemptions-back-office/pull/921) ([timstone](https://github.com/timstone))
- Feature/postcode search for all address [\#919](https://github.com/DEFRA/waste-exemptions-back-office/pull/919) ([Beckyrose200](https://github.com/Beckyrose200))
- Feature/site grid reference [\#918](https://github.com/DEFRA/waste-exemptions-back-office/pull/918) ([Beckyrose200](https://github.com/Beckyrose200))
- Adding telephone to the search criteria [\#911](https://github.com/DEFRA/waste-exemptions-back-office/pull/911) ([Beckyrose200](https://github.com/Beckyrose200))
- Add renewals column to boxi exemptions export [\#904](https://github.com/DEFRA/waste-exemptions-back-office/pull/904) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

**Fixed bugs:**

- Fix address sub-headings on details page [\#923](https://github.com/DEFRA/waste-exemptions-back-office/pull/923) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Fix search issue [\#914](https://github.com/DEFRA/waste-exemptions-back-office/pull/914) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

**Merged pull requests:**

- Bump rails from 6.1.6.1 to 6.1.7 [\#922](https://github.com/DEFRA/waste-exemptions-back-office/pull/922) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `8ab6047` to `4e96995` [\#920](https://github.com/DEFRA/waste-exemptions-back-office/pull/920) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump faker from 2.22.0 to 2.23.0 [\#917](https://github.com/DEFRA/waste-exemptions-back-office/pull/917) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump defra\_ruby\_aws from 0.4.1 to 0.5.0 [\#915](https://github.com/DEFRA/waste-exemptions-back-office/pull/915) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump webmock from 3.17.1 to 3.18.1 [\#913](https://github.com/DEFRA/waste-exemptions-back-office/pull/913) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump pry-byebug from 3.9.0 to 3.10.1 [\#912](https://github.com/DEFRA/waste-exemptions-back-office/pull/912) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `9c9b495` to `8ab6047` [\#910](https://github.com/DEFRA/waste-exemptions-back-office/pull/910) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump paper\_trail from 12.3.0 to 13.0.0 [\#909](https://github.com/DEFRA/waste-exemptions-back-office/pull/909) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump govuk\_design\_system\_formbuilder from 3.1.1 to 3.1.2 [\#908](https://github.com/DEFRA/waste-exemptions-back-office/pull/908) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump bullet from 7.0.2 to 7.0.3 [\#906](https://github.com/DEFRA/waste-exemptions-back-office/pull/906) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `6120260` to `9c9b495` [\#905](https://github.com/DEFRA/waste-exemptions-back-office/pull/905) ([dependabot[bot]](https://github.com/apps/dependabot))
- Update CHANGELOG [\#903](https://github.com/DEFRA/waste-exemptions-back-office/pull/903) ([Beckyrose200](https://github.com/Beckyrose200))
- Bump webmock from 3.16.0 to 3.17.1 [\#901](https://github.com/DEFRA/waste-exemptions-back-office/pull/901) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump pg from 1.4.2 to 1.4.3 [\#900](https://github.com/DEFRA/waste-exemptions-back-office/pull/900) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.6.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.6.0) (2022-08-10)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.5.1...v2.6.0)

**Implemented enhancements:**

- Send letters to contacts with no email address [\#884](https://github.com/DEFRA/waste-exemptions-back-office/pull/884) ([Beckyrose200](https://github.com/Beckyrose200))
- Renew link, companies house data retrieval [\#880](https://github.com/DEFRA/waste-exemptions-back-office/pull/880) ([Beckyrose200](https://github.com/Beckyrose200))
- Map assistance\_mode values for boxi registrations export [\#877](https://github.com/DEFRA/waste-exemptions-back-office/pull/877) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Send renewal letters 30 days before expiry [\#858](https://github.com/DEFRA/waste-exemptions-back-office/pull/858) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Success banner and failure banner added for CH refresh button [\#856](https://github.com/DEFRA/waste-exemptions-back-office/pull/856) ([Beckyrose200](https://github.com/Beckyrose200))
- \[1846\] Use new template for renewal letter [\#854](https://github.com/DEFRA/waste-exemptions-back-office/pull/854) ([d-a-v-e](https://github.com/d-a-v-e))
- Refresh companies house button working [\#849](https://github.com/DEFRA/waste-exemptions-back-office/pull/849) ([Beckyrose200](https://github.com/Beckyrose200))
- \[1868\] WEX - delete registrations that have been expired/ceased/revoked 7 years prior [\#845](https://github.com/DEFRA/waste-exemptions-back-office/pull/845) ([d-a-v-e](https://github.com/d-a-v-e))
- \[1876\] Back Office relabel operator name on registration lookup [\#838](https://github.com/DEFRA/waste-exemptions-back-office/pull/838) ([d-a-v-e](https://github.com/d-a-v-e))

**Fixed bugs:**

- Added db migration for companies\_house\_updated\_at [\#874](https://github.com/DEFRA/waste-exemptions-back-office/pull/874) ([Beckyrose200](https://github.com/Beckyrose200))
- \[1932\] Fix grid references service [\#869](https://github.com/DEFRA/waste-exemptions-back-office/pull/869) ([d-a-v-e](https://github.com/d-a-v-e))
- commenting out spec file [\#864](https://github.com/DEFRA/waste-exemptions-back-office/pull/864) ([Beckyrose200](https://github.com/Beckyrose200))
- Allow renewal letter lead time to be configurable [\#861](https://github.com/DEFRA/waste-exemptions-back-office/pull/861) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

**Merged pull requests:**

- Bump waste\_exemptions\_engine from `589a2cb` to `6120260` [\#902](https://github.com/DEFRA/waste-exemptions-back-office/pull/902) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `a598e32` to `589a2cb` [\#898](https://github.com/DEFRA/waste-exemptions-back-office/pull/898) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `bd43e4c` to `a598e32` [\#897](https://github.com/DEFRA/waste-exemptions-back-office/pull/897) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `c78ca43` to `bd43e4c` [\#896](https://github.com/DEFRA/waste-exemptions-back-office/pull/896) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump webmock from 3.14.0 to 3.16.0 [\#895](https://github.com/DEFRA/waste-exemptions-back-office/pull/895) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump faker from 2.21.0 to 2.22.0 [\#894](https://github.com/DEFRA/waste-exemptions-back-office/pull/894) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump pg from 1.4.1 to 1.4.2 [\#893](https://github.com/DEFRA/waste-exemptions-back-office/pull/893) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump dotenv-rails from 2.7.6 to 2.8.1 [\#892](https://github.com/DEFRA/waste-exemptions-back-office/pull/892) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump govuk\_design\_system\_formbuilder from 3.1.0 to 3.1.1 [\#891](https://github.com/DEFRA/waste-exemptions-back-office/pull/891) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `4a4d82f` to `c78ca43` [\#890](https://github.com/DEFRA/waste-exemptions-back-office/pull/890) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `cad8ce4` to `4a4d82f` [\#889](https://github.com/DEFRA/waste-exemptions-back-office/pull/889) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `70dc406` to `cad8ce4` [\#888](https://github.com/DEFRA/waste-exemptions-back-office/pull/888) ([dependabot[bot]](https://github.com/apps/dependabot))
- Set host\_is\_back\_office [\#887](https://github.com/DEFRA/waste-exemptions-back-office/pull/887) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump waste\_exemptions\_engine from `1aaa114` to `70dc406` [\#886](https://github.com/DEFRA/waste-exemptions-back-office/pull/886) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `b4198da` to `1aaa114` [\#883](https://github.com/DEFRA/waste-exemptions-back-office/pull/883) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rails from 6.1.6 to 6.1.6.1 [\#882](https://github.com/DEFRA/waste-exemptions-back-office/pull/882) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `9e2f3c5` to `b4198da` [\#881](https://github.com/DEFRA/waste-exemptions-back-office/pull/881) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `da3e2ec` to `9e2f3c5` [\#879](https://github.com/DEFRA/waste-exemptions-back-office/pull/879) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `ae6dcce` to `da3e2ec` [\#876](https://github.com/DEFRA/waste-exemptions-back-office/pull/876) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `8c6a305` to `ae6dcce` [\#873](https://github.com/DEFRA/waste-exemptions-back-office/pull/873) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `8cc717c` to `8c6a305` [\#872](https://github.com/DEFRA/waste-exemptions-back-office/pull/872) ([dependabot[bot]](https://github.com/apps/dependabot))
- log reference [\#871](https://github.com/DEFRA/waste-exemptions-back-office/pull/871) ([d-a-v-e](https://github.com/d-a-v-e))
- \[1932\] change log message [\#870](https://github.com/DEFRA/waste-exemptions-back-office/pull/870) ([d-a-v-e](https://github.com/d-a-v-e))
- Bump govuk\_design\_system\_formbuilder from 3.0.3 to 3.1.0 [\#868](https://github.com/DEFRA/waste-exemptions-back-office/pull/868) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump pg from 1.3.5 to 1.4.1 [\#867](https://github.com/DEFRA/waste-exemptions-back-office/pull/867) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump cancancan from 3.3.0 to 3.4.0 [\#866](https://github.com/DEFRA/waste-exemptions-back-office/pull/866) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `05b9f02` to `8cc717c` [\#863](https://github.com/DEFRA/waste-exemptions-back-office/pull/863) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `c511505` to `05b9f02` [\#862](https://github.com/DEFRA/waste-exemptions-back-office/pull/862) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `6f80a37` to `c511505` [\#860](https://github.com/DEFRA/waste-exemptions-back-office/pull/860) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump jmespath from 1.4.0 to 1.6.1 [\#859](https://github.com/DEFRA/waste-exemptions-back-office/pull/859) ([dependabot[bot]](https://github.com/apps/dependabot))
- renewal\_window\_before\_expiry\_in\_days coerced to int [\#857](https://github.com/DEFRA/waste-exemptions-back-office/pull/857) ([d-a-v-e](https://github.com/d-a-v-e))
- Bump bullet from 7.0.1 to 7.0.2 [\#855](https://github.com/DEFRA/waste-exemptions-back-office/pull/855) ([dependabot[bot]](https://github.com/apps/dependabot))
- \[1868\] Use expires\_on over updated\_at [\#853](https://github.com/DEFRA/waste-exemptions-back-office/pull/853) ([d-a-v-e](https://github.com/d-a-v-e))
- Bump waste\_exemptions\_engine from `fa6e4a7` to `6f80a37` [\#851](https://github.com/DEFRA/waste-exemptions-back-office/pull/851) ([dependabot[bot]](https://github.com/apps/dependabot))
- db update scheme to latest migration [\#850](https://github.com/DEFRA/waste-exemptions-back-office/pull/850) ([Beckyrose200](https://github.com/Beckyrose200))
- Bump waste\_exemptions\_engine from `0452dde` to `fa6e4a7` [\#848](https://github.com/DEFRA/waste-exemptions-back-office/pull/848) ([dependabot[bot]](https://github.com/apps/dependabot))
- \[1868\] Log with puts [\#847](https://github.com/DEFRA/waste-exemptions-back-office/pull/847) ([d-a-v-e](https://github.com/d-a-v-e))
- Bump jquery-rails from 4.4.0 to 4.5.0 [\#846](https://github.com/DEFRA/waste-exemptions-back-office/pull/846) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump govuk\_design\_system\_formbuilder from 3.0.2 to 3.0.3 [\#844](https://github.com/DEFRA/waste-exemptions-back-office/pull/844) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `304a2d6` to `0452dde` [\#843](https://github.com/DEFRA/waste-exemptions-back-office/pull/843) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `6f6c934` to `2b53151` [\#841](https://github.com/DEFRA/waste-exemptions-back-office/pull/841) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump faker from 2.20.0 to 2.21.0 [\#840](https://github.com/DEFRA/waste-exemptions-back-office/pull/840) ([dependabot[bot]](https://github.com/apps/dependabot))
- Update CHANGELOG [\#839](https://github.com/DEFRA/waste-exemptions-back-office/pull/839) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump rails from 6.1.5.1 to 6.1.6 [\#835](https://github.com/DEFRA/waste-exemptions-back-office/pull/835) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.5.1](https://github.com/defra/waste-exemptions-back-office/tree/v2.5.1) (2022-05-12)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.5.0...v2.5.1)

**Fixed bugs:**

- Update db schema with latest migrations [\#837](https://github.com/DEFRA/waste-exemptions-back-office/pull/837) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Revert rubocop-inspired change to config.ru to fix Rails config loading [\#796](https://github.com/DEFRA/waste-exemptions-back-office/pull/796) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))

**Merged pull requests:**

- Bump waste\_exemptions\_engine from `3b6cf55` to `6f6c934` [\#836](https://github.com/DEFRA/waste-exemptions-back-office/pull/836) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `57c8202` to `3b6cf55` [\#834](https://github.com/DEFRA/waste-exemptions-back-office/pull/834) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `c7a0349` to `57c8202` [\#833](https://github.com/DEFRA/waste-exemptions-back-office/pull/833) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rails from 6.1.5 to 6.1.5.1 [\#831](https://github.com/DEFRA/waste-exemptions-back-office/pull/831) ([dependabot[bot]](https://github.com/apps/dependabot))
- Force github to run apt-get update before installing dependencies [\#830](https://github.com/DEFRA/waste-exemptions-back-office/pull/830) ([Beckyrose200](https://github.com/Beckyrose200))
- Bump rspec-rails from 5.1.1 to 5.1.2 [\#829](https://github.com/DEFRA/waste-exemptions-back-office/pull/829) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `271bf34` to `c7a0349` [\#827](https://github.com/DEFRA/waste-exemptions-back-office/pull/827) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump nokogiri from 1.13.3 to 1.13.4 [\#826](https://github.com/DEFRA/waste-exemptions-back-office/pull/826) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `10e589f` to `271bf34` [\#825](https://github.com/DEFRA/waste-exemptions-back-office/pull/825) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `5774d02` to `10e589f` [\#824](https://github.com/DEFRA/waste-exemptions-back-office/pull/824) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `eaff485` to `5774d02` [\#822](https://github.com/DEFRA/waste-exemptions-back-office/pull/822) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `3eadad3` to `eaff485` [\#821](https://github.com/DEFRA/waste-exemptions-back-office/pull/821) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump pg from 1.3.4 to 1.3.5 [\#820](https://github.com/DEFRA/waste-exemptions-back-office/pull/820) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `75419db` to `3eadad3` [\#819](https://github.com/DEFRA/waste-exemptions-back-office/pull/819) ([dependabot[bot]](https://github.com/apps/dependabot))
- Gem updates [\#817](https://github.com/DEFRA/waste-exemptions-back-office/pull/817) ([tobyprivett](https://github.com/tobyprivett))
- Bump rails from 6.1.4.4 to 6.1.4.6 [\#809](https://github.com/DEFRA/waste-exemptions-back-office/pull/809) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump govuk\_design\_system\_formbuilder from 3.0.1 to 3.0.2 [\#808](https://github.com/DEFRA/waste-exemptions-back-office/pull/808) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `5ab56c9` to `e200c6a` [\#806](https://github.com/DEFRA/waste-exemptions-back-office/pull/806) ([dependabot[bot]](https://github.com/apps/dependabot))
- Fix db schema [\#805](https://github.com/DEFRA/waste-exemptions-back-office/pull/805) ([tobyprivett](https://github.com/tobyprivett))
- Bump waste\_exemptions\_engine from `89b492c` to `5ab56c9` [\#804](https://github.com/DEFRA/waste-exemptions-back-office/pull/804) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump brakeman [\#803](https://github.com/DEFRA/waste-exemptions-back-office/pull/803) ([tobyprivett](https://github.com/tobyprivett))
- Bump pg from 1.2.3 to 1.3.1 [\#802](https://github.com/DEFRA/waste-exemptions-back-office/pull/802) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rspec-rails from 5.0.2 to 5.1.0 [\#801](https://github.com/DEFRA/waste-exemptions-back-office/pull/801) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump govuk\_design\_system\_formbuilder from 2.8.0 to 3.0.1 [\#800](https://github.com/DEFRA/waste-exemptions-back-office/pull/800) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump paper\_trail from 12.1.0 to 12.2.0 [\#798](https://github.com/DEFRA/waste-exemptions-back-office/pull/798) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `18a10e1` to `89b492c` [\#797](https://github.com/DEFRA/waste-exemptions-back-office/pull/797) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `8c2d44c` to `18a10e1` [\#795](https://github.com/DEFRA/waste-exemptions-back-office/pull/795) ([dependabot[bot]](https://github.com/apps/dependabot))
- Feature/ruby 1724 cleanup [\#794](https://github.com/DEFRA/waste-exemptions-back-office/pull/794) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Feature/ruby 1724 cleanup [\#793](https://github.com/DEFRA/waste-exemptions-back-office/pull/793) ([PaulDoyle-EA](https://github.com/PaulDoyle-EA))
- Bump bullet from 7.0.0 to 7.0.1 [\#792](https://github.com/DEFRA/waste-exemptions-back-office/pull/792) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `9673b87` to `8c2d44c` [\#790](https://github.com/DEFRA/waste-exemptions-back-office/pull/790) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump loofah gem [\#788](https://github.com/DEFRA/waste-exemptions-back-office/pull/788) ([tobyprivett](https://github.com/tobyprivett))
- Gem updates [\#787](https://github.com/DEFRA/waste-exemptions-back-office/pull/787) ([tobyprivett](https://github.com/tobyprivett))
- Enable Brakeman for security scanning [\#786](https://github.com/DEFRA/waste-exemptions-back-office/pull/786) ([tobyprivett](https://github.com/tobyprivett))

## [v2.5.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.5.0) (2021-12-06)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.4.0...v2.5.0)

**Implemented enhancements:**

- Styling: Deregister exemption\(s\) [\#771](https://github.com/DEFRA/waste-exemptions-back-office/pull/771) ([tobyprivett](https://github.com/tobyprivett))
- Remove redundant static pages that are served by the front office [\#769](https://github.com/DEFRA/waste-exemptions-back-office/pull/769) ([tobyprivett](https://github.com/tobyprivett))
- Styling: Assisted digital privacy notice [\#768](https://github.com/DEFRA/waste-exemptions-back-office/pull/768) ([tobyprivett](https://github.com/tobyprivett))
- Styling: 'Your account does not have permission' [\#767](https://github.com/DEFRA/waste-exemptions-back-office/pull/767) ([tobyprivett](https://github.com/tobyprivett))
- Style the devise links [\#766](https://github.com/DEFRA/waste-exemptions-back-office/pull/766) ([tobyprivett](https://github.com/tobyprivett))
- Restyle resend renewal letter page [\#763](https://github.com/DEFRA/waste-exemptions-back-office/pull/763) ([irisfaraway](https://github.com/irisfaraway))
- Ensure email summary links work [\#761](https://github.com/DEFRA/waste-exemptions-back-office/pull/761) ([tobyprivett](https://github.com/tobyprivett))
- Resend an email flash messages [\#760](https://github.com/DEFRA/waste-exemptions-back-office/pull/760) ([tobyprivett](https://github.com/tobyprivett))
- Resend a letter pages [\#759](https://github.com/DEFRA/waste-exemptions-back-office/pull/759) ([tobyprivett](https://github.com/tobyprivett))
- Bulk exports page [\#758](https://github.com/DEFRA/waste-exemptions-back-office/pull/758) ([tobyprivett](https://github.com/tobyprivett))

**Fixed bugs:**

- Remove redundant aria-labelledby [\#764](https://github.com/DEFRA/waste-exemptions-back-office/pull/764) ([irisfaraway](https://github.com/irisfaraway))
- Fix user roles page header styling [\#762](https://github.com/DEFRA/waste-exemptions-back-office/pull/762) ([irisfaraway](https://github.com/irisfaraway))

**Merged pull requests:**

- Bump govuk\_design\_system\_formbuilder from 2.7.5 to 2.8.0 [\#778](https://github.com/DEFRA/waste-exemptions-back-office/pull/778) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump spring from 2.1.1 to 3.1.1 [\#777](https://github.com/DEFRA/waste-exemptions-back-office/pull/777) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `83d52c2` to `b079e54` [\#774](https://github.com/DEFRA/waste-exemptions-back-office/pull/774) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `25849e9` to `83d52c2` [\#772](https://github.com/DEFRA/waste-exemptions-back-office/pull/772) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `c0620c5` to `25849e9` [\#770](https://github.com/DEFRA/waste-exemptions-back-office/pull/770) ([dependabot[bot]](https://github.com/apps/dependabot))
- Devise pages [\#765](https://github.com/DEFRA/waste-exemptions-back-office/pull/765) ([tobyprivett](https://github.com/tobyprivett))
- Bump waste\_exemptions\_engine from `4155fa8` to `c0620c5` [\#757](https://github.com/DEFRA/waste-exemptions-back-office/pull/757) ([dependabot[bot]](https://github.com/apps/dependabot))
- Styling: Activate or deactivate a user [\#756](https://github.com/DEFRA/waste-exemptions-back-office/pull/756) ([tobyprivett](https://github.com/tobyprivett))
- Styling: Change user role [\#755](https://github.com/DEFRA/waste-exemptions-back-office/pull/755) ([tobyprivett](https://github.com/tobyprivett))
- Styling: Invite user [\#754](https://github.com/DEFRA/waste-exemptions-back-office/pull/754) ([tobyprivett](https://github.com/tobyprivett))
- Styling: Manage users      [\#753](https://github.com/DEFRA/waste-exemptions-back-office/pull/753) ([tobyprivett](https://github.com/tobyprivett))
- Styling: Edit process forms [\#752](https://github.com/DEFRA/waste-exemptions-back-office/pull/752) ([tobyprivett](https://github.com/tobyprivett))
- Ensure the dashboard renders for a transient registration [\#751](https://github.com/DEFRA/waste-exemptions-back-office/pull/751) ([tobyprivett](https://github.com/tobyprivett))
- Bump waste\_exemptions\_engine from `b7cb01c` to `4155fa8` [\#750](https://github.com/DEFRA/waste-exemptions-back-office/pull/750) ([dependabot[bot]](https://github.com/apps/dependabot))
- Styling: View registration page [\#749](https://github.com/DEFRA/waste-exemptions-back-office/pull/749) ([tobyprivett](https://github.com/tobyprivett))
- Navigation header edits [\#748](https://github.com/DEFRA/waste-exemptions-back-office/pull/748) ([tobyprivett](https://github.com/tobyprivett))
- Styling: Dashboard [\#747](https://github.com/DEFRA/waste-exemptions-back-office/pull/747) ([tobyprivett](https://github.com/tobyprivett))
- Bump waste\_exemptions\_engine from `2717616` to `b7cb01c` [\#745](https://github.com/DEFRA/waste-exemptions-back-office/pull/745) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `5eb2f05` to `2717616` [\#744](https://github.com/DEFRA/waste-exemptions-back-office/pull/744) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `84bf561` to `5eb2f05` [\#743](https://github.com/DEFRA/waste-exemptions-back-office/pull/743) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `9e67518` to `84bf561` [\#742](https://github.com/DEFRA/waste-exemptions-back-office/pull/742) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump govuk\_design\_system\_formbuilder from 2.7.4 to 2.7.5 [\#740](https://github.com/DEFRA/waste-exemptions-back-office/pull/740) ([dependabot[bot]](https://github.com/apps/dependabot))
- Design system [\#738](https://github.com/DEFRA/waste-exemptions-back-office/pull/738) ([tobyprivett](https://github.com/tobyprivett))
- Bump waste\_exemptions\_engine from `4b5112c` to `69fde8b` [\#735](https://github.com/DEFRA/waste-exemptions-back-office/pull/735) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump defra\_ruby\_features from 0.1.1 to 0.1.4 [\#734](https://github.com/DEFRA/waste-exemptions-back-office/pull/734) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump faker from 2.18.0 to 2.19.0 [\#733](https://github.com/DEFRA/waste-exemptions-back-office/pull/733) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump bullet from 6.1.4 to 6.1.5 [\#732](https://github.com/DEFRA/waste-exemptions-back-office/pull/732) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rspec-rails from 5.0.1 to 5.0.2 [\#731](https://github.com/DEFRA/waste-exemptions-back-office/pull/731) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump webmock from 3.13.0 to 3.14.0 [\#728](https://github.com/DEFRA/waste-exemptions-back-office/pull/728) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `c5a73dd` to `4b5112c` [\#726](https://github.com/DEFRA/waste-exemptions-back-office/pull/726) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump addressable from 2.7.0 to 2.8.0 [\#725](https://github.com/DEFRA/waste-exemptions-back-office/pull/725) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubyzip from 2.3.1 to 2.3.2 [\#724](https://github.com/DEFRA/waste-exemptions-back-office/pull/724) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubyzip from 2.3.0 to 2.3.1 [\#723](https://github.com/DEFRA/waste-exemptions-back-office/pull/723) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `c68a9b6` to `c5a73dd` [\#722](https://github.com/DEFRA/waste-exemptions-back-office/pull/722) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `2b02b9e` to `c68a9b6` [\#721](https://github.com/DEFRA/waste-exemptions-back-office/pull/721) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump github\_changelog\_generator from 1.16.3 to 1.16.4 [\#720](https://github.com/DEFRA/waste-exemptions-back-office/pull/720) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.4.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.4.0) (2021-05-20)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.3.0...v2.4.0)

**Merged pull requests:**

- Bump waste\_exemptions\_engine from `e23fbe8` to `2b02b9e` [\#719](https://github.com/DEFRA/waste-exemptions-back-office/pull/719) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `d084933` to `e23fbe8` [\#718](https://github.com/DEFRA/waste-exemptions-back-office/pull/718) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump faker from 2.17.0 to 2.18.0 [\#717](https://github.com/DEFRA/waste-exemptions-back-office/pull/717) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump github\_changelog\_generator from 1.16.2 to 1.16.3 [\#716](https://github.com/DEFRA/waste-exemptions-back-office/pull/716) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump webmock from 3.12.2 to 3.13.0 [\#715](https://github.com/DEFRA/waste-exemptions-back-office/pull/715) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `062cb10` to `d084933` [\#714](https://github.com/DEFRA/waste-exemptions-back-office/pull/714) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `72d4834` to `062cb10` [\#713](https://github.com/DEFRA/waste-exemptions-back-office/pull/713) ([dependabot[bot]](https://github.com/apps/dependabot))
- Update minimum Rails version [\#712](https://github.com/DEFRA/waste-exemptions-back-office/pull/712) ([irisfaraway](https://github.com/irisfaraway))
- Bump factory\_bot\_rails from 6.1.0 to 6.2.0 [\#711](https://github.com/DEFRA/waste-exemptions-back-office/pull/711) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `c13b551` to `72d4834` [\#710](https://github.com/DEFRA/waste-exemptions-back-office/pull/710) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rails from 6.0.3.6 to 6.0.3.7 [\#709](https://github.com/DEFRA/waste-exemptions-back-office/pull/709) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rexml from 3.2.4 to 3.2.5 [\#708](https://github.com/DEFRA/waste-exemptions-back-office/pull/708) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump devise from 4.7.3 to 4.8.0 [\#707](https://github.com/DEFRA/waste-exemptions-back-office/pull/707) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `1574734` to `c13b551` [\#706](https://github.com/DEFRA/waste-exemptions-back-office/pull/706) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump github\_changelog\_generator from 1.16.1 to 1.16.2 [\#705](https://github.com/DEFRA/waste-exemptions-back-office/pull/705) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `c85e669` to `1574734` [\#704](https://github.com/DEFRA/waste-exemptions-back-office/pull/704) ([dependabot[bot]](https://github.com/apps/dependabot))
- Update Ubuntu version in CI [\#703](https://github.com/DEFRA/waste-exemptions-back-office/pull/703) ([irisfaraway](https://github.com/irisfaraway))
- Remove config for AWS letters bucket [\#702](https://github.com/DEFRA/waste-exemptions-back-office/pull/702) ([irisfaraway](https://github.com/irisfaraway))
- Bump devise\_invitable from 2.0.4 to 2.0.5 [\#701](https://github.com/DEFRA/waste-exemptions-back-office/pull/701) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.3.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.3.0) (2021-04-15)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.2.0...v2.3.0)

**Implemented enhancements:**

- Resend confirmation email on demand [\#698](https://github.com/DEFRA/waste-exemptions-back-office/pull/698) ([irisfaraway](https://github.com/irisfaraway))

**Merged pull requests:**

- Bump waste\_exemptions\_engine from `9664fb3` to `c85e669` [\#700](https://github.com/DEFRA/waste-exemptions-back-office/pull/700) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump devise\_invitable from 2.0.3 to 2.0.4 [\#699](https://github.com/DEFRA/waste-exemptions-back-office/pull/699) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `bceb28d` to `ee10f25` [\#697](https://github.com/DEFRA/waste-exemptions-back-office/pull/697) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rails from 6.0.3.5 to 6.0.3.6 [\#696](https://github.com/DEFRA/waste-exemptions-back-office/pull/696) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump webmock from 3.12.1 to 3.12.2 [\#695](https://github.com/DEFRA/waste-exemptions-back-office/pull/695) ([dependabot[bot]](https://github.com/apps/dependabot))
- Remove old PDF letter export functionality [\#694](https://github.com/DEFRA/waste-exemptions-back-office/pull/694) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_exemptions\_engine from `f10cd26` to `bceb28d` [\#693](https://github.com/DEFRA/waste-exemptions-back-office/pull/693) ([dependabot[bot]](https://github.com/apps/dependabot))
- Update to mimemagic 0.3.7 [\#692](https://github.com/DEFRA/waste-exemptions-back-office/pull/692) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_exemptions\_engine from `f50675f` to `f10cd26` [\#691](https://github.com/DEFRA/waste-exemptions-back-office/pull/691) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump github\_changelog\_generator from 1.15.2 to 1.16.1 [\#690](https://github.com/DEFRA/waste-exemptions-back-office/pull/690) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rspec-rails from 5.0.0 to 5.0.1 [\#688](https://github.com/DEFRA/waste-exemptions-back-office/pull/688) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.2.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.2.0) (2021-03-15)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.1.0...v2.2.0)

**Implemented enhancements:**

- Resend AD renewal letters on demand [\#682](https://github.com/DEFRA/waste-exemptions-back-office/pull/682) ([irisfaraway](https://github.com/irisfaraway))
- Resend AD confirmation letter on demand [\#681](https://github.com/DEFRA/waste-exemptions-back-office/pull/681) ([irisfaraway](https://github.com/irisfaraway))
- Bulk-send AD renewal letters via Notify [\#673](https://github.com/DEFRA/waste-exemptions-back-office/pull/673) ([irisfaraway](https://github.com/irisfaraway))
- Identify registrations which should receive Notify renewal letter [\#672](https://github.com/DEFRA/waste-exemptions-back-office/pull/672) ([irisfaraway](https://github.com/irisfaraway))
- Set up presenter and service for Notify renewal letters [\#664](https://github.com/DEFRA/waste-exemptions-back-office/pull/664) ([irisfaraway](https://github.com/irisfaraway))
- Add service and rake task for Notify confirmation letter [\#647](https://github.com/DEFRA/waste-exemptions-back-office/pull/647) ([irisfaraway](https://github.com/irisfaraway))
- Add presenter for Notify version of confirmation letter [\#646](https://github.com/DEFRA/waste-exemptions-back-office/pull/646) ([irisfaraway](https://github.com/irisfaraway))

**Fixed bugs:**

- Confirmation letters can only be resent to active regs [\#687](https://github.com/DEFRA/waste-exemptions-back-office/pull/687) ([irisfaraway](https://github.com/irisfaraway))

**Merged pull requests:**

- Bump waste\_exemptions\_engine from `7dfaeba` to `f50675f` [\#686](https://github.com/DEFRA/waste-exemptions-back-office/pull/686) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump faker from 2.16.0 to 2.17.0 [\#685](https://github.com/DEFRA/waste-exemptions-back-office/pull/685) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rspec-rails from 4.1.0 to 5.0.0 [\#684](https://github.com/DEFRA/waste-exemptions-back-office/pull/684) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `dfa481a` to `7dfaeba` [\#683](https://github.com/DEFRA/waste-exemptions-back-office/pull/683) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rspec-rails from 4.0.2 to 4.1.0 [\#680](https://github.com/DEFRA/waste-exemptions-back-office/pull/680) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump webmock from 3.12.0 to 3.12.1 [\#679](https://github.com/DEFRA/waste-exemptions-back-office/pull/679) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `e01fb4b` to `dfa481a` [\#678](https://github.com/DEFRA/waste-exemptions-back-office/pull/678) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump bullet from 6.1.3 to 6.1.4 [\#677](https://github.com/DEFRA/waste-exemptions-back-office/pull/677) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump webmock from 3.11.3 to 3.12.0 [\#676](https://github.com/DEFRA/waste-exemptions-back-office/pull/676) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `3d3c419` to `e01fb4b` [\#675](https://github.com/DEFRA/waste-exemptions-back-office/pull/675) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump webmock from 3.11.2 to 3.11.3 [\#674](https://github.com/DEFRA/waste-exemptions-back-office/pull/674) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `27f0125` to `3d3c419` [\#671](https://github.com/DEFRA/waste-exemptions-back-office/pull/671) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `01d45d8` to `27f0125` [\#670](https://github.com/DEFRA/waste-exemptions-back-office/pull/670) ([dependabot[bot]](https://github.com/apps/dependabot))
- Configure WEX AD email address instead of hardcoding [\#669](https://github.com/DEFRA/waste-exemptions-back-office/pull/669) ([irisfaraway](https://github.com/irisfaraway))
- Change Ubuntu version for GH Actions build [\#668](https://github.com/DEFRA/waste-exemptions-back-office/pull/668) ([irisfaraway](https://github.com/irisfaraway))
- Remove files that were moved to engine [\#666](https://github.com/DEFRA/waste-exemptions-back-office/pull/666) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_exemptions\_engine from `2e753b7` to `e7e5840` [\#665](https://github.com/DEFRA/waste-exemptions-back-office/pull/665) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rails from 6.0.3.4 to 6.0.3.5 [\#661](https://github.com/DEFRA/waste-exemptions-back-office/pull/661) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump timecop from 0.9.3 to 0.9.4 [\#660](https://github.com/DEFRA/waste-exemptions-back-office/pull/660) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump faker from 2.15.1 to 2.16.0 [\#659](https://github.com/DEFRA/waste-exemptions-back-office/pull/659) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump timecop from 0.9.2 to 0.9.3 [\#657](https://github.com/DEFRA/waste-exemptions-back-office/pull/657) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump database\_cleaner from 1.8.5 to 2.0.1 [\#655](https://github.com/DEFRA/waste-exemptions-back-office/pull/655) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump webmock from 3.10.0 to 3.11.2 [\#652](https://github.com/DEFRA/waste-exemptions-back-office/pull/652) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump pgreset from 0.1.1 to 0.3 [\#650](https://github.com/DEFRA/waste-exemptions-back-office/pull/650) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump bullet from 6.1.2 to 6.1.3 [\#649](https://github.com/DEFRA/waste-exemptions-back-office/pull/649) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rspec-rails from 4.0.1 to 4.0.2 [\#644](https://github.com/DEFRA/waste-exemptions-back-office/pull/644) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `66b7631` to `2e753b7` [\#642](https://github.com/DEFRA/waste-exemptions-back-office/pull/642) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump bullet from 6.1.0 to 6.1.2 [\#641](https://github.com/DEFRA/waste-exemptions-back-office/pull/641) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v2.1.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.1.0) (2020-12-10)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.0.1...v2.1.0)

**Implemented enhancements:**

- Upload EPR exports to EPR folder [\#636](https://github.com/DEFRA/waste-exemptions-back-office/pull/636) ([irisfaraway](https://github.com/irisfaraway))
- Resend reminder emails using Notify instead of mailer [\#600](https://github.com/DEFRA/waste-exemptions-back-office/pull/600) ([irisfaraway](https://github.com/irisfaraway))
- Replace mailer with Notify services in RenewalReminderServices [\#599](https://github.com/DEFRA/waste-exemptions-back-office/pull/599) ([irisfaraway](https://github.com/irisfaraway))
- Add Notify service for second renewal reminder email [\#598](https://github.com/DEFRA/waste-exemptions-back-office/pull/598) ([irisfaraway](https://github.com/irisfaraway))
- Set up Notify service for first reminder email [\#597](https://github.com/DEFRA/waste-exemptions-back-office/pull/597) ([irisfaraway](https://github.com/irisfaraway))
- Add developer role to back-office [\#590](https://github.com/DEFRA/waste-exemptions-back-office/pull/590) ([Cruikshanks](https://github.com/Cruikshanks))
- Integrate defra-ruby-features engine [\#573](https://github.com/DEFRA/waste-exemptions-back-office/pull/573) ([cintamani](https://github.com/cintamani))

**Fixed bugs:**

- Update text for one-off area fix [\#639](https://github.com/DEFRA/waste-exemptions-back-office/pull/639) ([irisfaraway](https://github.com/irisfaraway))
- Add one-off task to fix areas for certain regs [\#634](https://github.com/DEFRA/waste-exemptions-back-office/pull/634) ([irisfaraway](https://github.com/irisfaraway))
- Make sure exemption list is in correct order [\#605](https://github.com/DEFRA/waste-exemptions-back-office/pull/605) ([irisfaraway](https://github.com/irisfaraway))
- Fix Notify rake tasks [\#603](https://github.com/DEFRA/waste-exemptions-back-office/pull/603) ([irisfaraway](https://github.com/irisfaraway))
- Fix wrong letter cleanup service called [\#585](https://github.com/DEFRA/waste-exemptions-back-office/pull/585) ([Cruikshanks](https://github.com/Cruikshanks))

**Merged pull requests:**

- Bump waste\_exemptions\_engine from `c682f03` to `66b7631` [\#640](https://github.com/DEFRA/waste-exemptions-back-office/pull/640) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_exemptions\_engine from `8b6eefd` to `c682f03` [\#638](https://github.com/DEFRA/waste-exemptions-back-office/pull/638) ([dependabot[bot]](https://github.com/apps/dependabot))
- Create Dependabot config file [\#637](https://github.com/DEFRA/waste-exemptions-back-office/pull/637) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `37c54bf` to `8b6eefd` [\#635](https://github.com/DEFRA/waste-exemptions-back-office/pull/635) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `20b1494` to `37c54bf` [\#633](https://github.com/DEFRA/waste-exemptions-back-office/pull/633) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Replace Travis CI with GitHub Actions [\#631](https://github.com/DEFRA/waste-exemptions-back-office/pull/631) ([irisfaraway](https://github.com/irisfaraway))
- Bump faker from 2.14.0 to 2.15.1 [\#630](https://github.com/DEFRA/waste-exemptions-back-office/pull/630) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump devise\_invitable from 2.0.2 to 2.0.3 [\#629](https://github.com/DEFRA/waste-exemptions-back-office/pull/629) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.9.4 to 3.10.0 [\#628](https://github.com/DEFRA/waste-exemptions-back-office/pull/628) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `3546f34` to `20b1494` [\#626](https://github.com/DEFRA/waste-exemptions-back-office/pull/626) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.9.3 to 3.9.4 [\#625](https://github.com/DEFRA/waste-exemptions-back-office/pull/625) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `5c74033` to `3546f34` [\#624](https://github.com/DEFRA/waste-exemptions-back-office/pull/624) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `8955166` to `5c74033` [\#623](https://github.com/DEFRA/waste-exemptions-back-office/pull/623) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `283a13d` to `8955166` [\#621](https://github.com/DEFRA/waste-exemptions-back-office/pull/621) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.9.2 to 3.9.3 [\#620](https://github.com/DEFRA/waste-exemptions-back-office/pull/620) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `ec26edc` to `283a13d` [\#619](https://github.com/DEFRA/waste-exemptions-back-office/pull/619) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump timecop from 0.9.1 to 0.9.2 [\#618](https://github.com/DEFRA/waste-exemptions-back-office/pull/618) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `0395f49` to `ec26edc` [\#617](https://github.com/DEFRA/waste-exemptions-back-office/pull/617) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.9.1 to 3.9.2 [\#616](https://github.com/DEFRA/waste-exemptions-back-office/pull/616) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `9756d37` to `0395f49` [\#615](https://github.com/DEFRA/waste-exemptions-back-office/pull/615) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rails from 6.0.3.3 to 6.0.3.4 [\#614](https://github.com/DEFRA/waste-exemptions-back-office/pull/614) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `9e9c51b` to `9756d37` [\#613](https://github.com/DEFRA/waste-exemptions-back-office/pull/613) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `849a6ff` to `9e9c51b` [\#612](https://github.com/DEFRA/waste-exemptions-back-office/pull/612) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump devise from 4.7.2 to 4.7.3 [\#611](https://github.com/DEFRA/waste-exemptions-back-office/pull/611) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump faker from 2.13.0 to 2.14.0 [\#610](https://github.com/DEFRA/waste-exemptions-back-office/pull/610) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.8.3 to 3.9.1 [\#609](https://github.com/DEFRA/waste-exemptions-back-office/pull/609) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `4002537` to `849a6ff` [\#607](https://github.com/DEFRA/waste-exemptions-back-office/pull/607) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rails from 6.0.3.2 to 6.0.3.3 [\#606](https://github.com/DEFRA/waste-exemptions-back-office/pull/606) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `321d389` to `4002537` [\#604](https://github.com/DEFRA/waste-exemptions-back-office/pull/604) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `389f5d0` to `321d389` [\#602](https://github.com/DEFRA/waste-exemptions-back-office/pull/602) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `3a8e510` to `389f5d0` [\#601](https://github.com/DEFRA/waste-exemptions-back-office/pull/601) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `675f6d4` to `3a8e510` [\#596](https://github.com/DEFRA/waste-exemptions-back-office/pull/596) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `4e396d3` to `675f6d4` [\#595](https://github.com/DEFRA/waste-exemptions-back-office/pull/595) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `5c4c5ff` to `4e396d3` [\#594](https://github.com/DEFRA/waste-exemptions-back-office/pull/594) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump spring from 2.1.0 to 2.1.1 [\#593](https://github.com/DEFRA/waste-exemptions-back-office/pull/593) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `f22a311` to `5c4c5ff` [\#592](https://github.com/DEFRA/waste-exemptions-back-office/pull/592) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Refactor how can? is stubbed in some tests [\#591](https://github.com/DEFRA/waste-exemptions-back-office/pull/591) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `265a84d` to `f22a311` [\#589](https://github.com/DEFRA/waste-exemptions-back-office/pull/589) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `fe020be` to `265a84d` [\#588](https://github.com/DEFRA/waste-exemptions-back-office/pull/588) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update whenever to latest [\#587](https://github.com/DEFRA/waste-exemptions-back-office/pull/587) ([Cruikshanks](https://github.com/Cruikshanks))
- Change AD confirm. letters job start time [\#586](https://github.com/DEFRA/waste-exemptions-back-office/pull/586) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `3f10b80` to `fe020be` [\#584](https://github.com/DEFRA/waste-exemptions-back-office/pull/584) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump dotenv-rails from 2.7.5 to 2.7.6 [\#583](https://github.com/DEFRA/waste-exemptions-back-office/pull/583) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v2.0.1](https://github.com/defra/waste-exemptions-back-office/tree/v2.0.1) (2020-07-10)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v2.0.0...v2.0.1)

**Implemented enhancements:**

- Update defra-ruby-aws to encryption configurable [\#579](https://github.com/DEFRA/waste-exemptions-back-office/pull/579) ([Cruikshanks](https://github.com/Cruikshanks))

**Merged pull requests:**

- Bump waste\_exemptions\_engine from `6f694c9` to `3f10b80` [\#582](https://github.com/DEFRA/waste-exemptions-back-office/pull/582) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Revert "Update defra-ruby-alert" [\#581](https://github.com/DEFRA/waste-exemptions-back-office/pull/581) ([Cruikshanks](https://github.com/Cruikshanks))
- Update defra-ruby-alert [\#580](https://github.com/DEFRA/waste-exemptions-back-office/pull/580) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `d850341` to `6f694c9` [\#578](https://github.com/DEFRA/waste-exemptions-back-office/pull/578) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump factory\_bot\_rails from 6.0.0 to 6.1.0 [\#577](https://github.com/DEFRA/waste-exemptions-back-office/pull/577) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `083079e` to `d850341` [\#575](https://github.com/DEFRA/waste-exemptions-back-office/pull/575) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Changes need to support switch to 'main' branch [\#574](https://github.com/DEFRA/waste-exemptions-back-office/pull/574) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `b1f1a3d` to `ee5841d` [\#572](https://github.com/DEFRA/waste-exemptions-back-office/pull/572) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rails-controller-testing from 1.0.4 to 1.0.5 [\#571](https://github.com/DEFRA/waste-exemptions-back-office/pull/571) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump faker from 2.12.0 to 2.13.0 [\#570](https://github.com/DEFRA/waste-exemptions-back-office/pull/570) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v2.0.0](https://github.com/defra/waste-exemptions-back-office/tree/v2.0.0) (2020-06-23)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v1.3.1...v2.0.0)

**Implemented enhancements:**

- Update defra-ruby-aws to AWS:KMS version [\#569](https://github.com/DEFRA/waste-exemptions-back-office/pull/569) ([Cruikshanks](https://github.com/Cruikshanks))
- Update ruby and rails [\#558](https://github.com/DEFRA/waste-exemptions-back-office/pull/558) ([cintamani](https://github.com/cintamani))
- Schedule run of ad confirmation letter task [\#554](https://github.com/DEFRA/waste-exemptions-back-office/pull/554) ([cintamani](https://github.com/cintamani))
- Generate bulk export letters and view [\#553](https://github.com/DEFRA/waste-exemptions-back-office/pull/553) ([cintamani](https://github.com/cintamani))

**Fixed bugs:**

- Update .travis.yml [\#551](https://github.com/DEFRA/waste-exemptions-back-office/pull/551) ([cintamani](https://github.com/cintamani))
- Fix SonarCloud code coverage reporting [\#538](https://github.com/DEFRA/waste-exemptions-back-office/pull/538) ([Cruikshanks](https://github.com/Cruikshanks))

**Security fixes:**

- Fix json dependency security issue [\#535](https://github.com/DEFRA/waste-exemptions-back-office/pull/535) ([Cruikshanks](https://github.com/Cruikshanks))

**Merged pull requests:**

- Bump waste\_exemptions\_engine from `a6828ff` to `b1f1a3d` [\#568](https://github.com/DEFRA/waste-exemptions-back-office/pull/568) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `4742c37` to `a6828ff` [\#567](https://github.com/DEFRA/waste-exemptions-back-office/pull/567) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump factory\_bot\_rails from 5.2.0 to 6.0.0 [\#566](https://github.com/DEFRA/waste-exemptions-back-office/pull/566) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rails from 6.0.3.1 to 6.0.3.2 [\#565](https://github.com/DEFRA/waste-exemptions-back-office/pull/565) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `d57062b` to `4742c37` [\#564](https://github.com/DEFRA/waste-exemptions-back-office/pull/564) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `f40ca17` to `d57062b` [\#563](https://github.com/DEFRA/waste-exemptions-back-office/pull/563) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_style from 0.2.1 to 0.2.2 [\#561](https://github.com/DEFRA/waste-exemptions-back-office/pull/561) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `9e4fd13` to `f40ca17` [\#560](https://github.com/DEFRA/waste-exemptions-back-office/pull/560) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump devise from 4.7.1 to 4.7.2 [\#559](https://github.com/DEFRA/waste-exemptions-back-office/pull/559) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `456aee6` to `e134b99` [\#557](https://github.com/DEFRA/waste-exemptions-back-office/pull/557) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump vcr from 5.1.0 to 6.0.0 [\#556](https://github.com/DEFRA/waste-exemptions-back-office/pull/556) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump kaminari from 1.2.0 to 1.2.1 [\#555](https://github.com/DEFRA/waste-exemptions-back-office/pull/555) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `de55f16` to `456aee6` [\#552](https://github.com/DEFRA/waste-exemptions-back-office/pull/552) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rails from 4.2.11.1 to 4.2.11.3 [\#550](https://github.com/DEFRA/waste-exemptions-back-office/pull/550) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `adc4d6d` to `de55f16` [\#549](https://github.com/DEFRA/waste-exemptions-back-office/pull/549) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump jquery-rails from 4.3.5 to 4.4.0 [\#548](https://github.com/DEFRA/waste-exemptions-back-office/pull/548) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `3c79bb3` to `adc4d6d` [\#547](https://github.com/DEFRA/waste-exemptions-back-office/pull/547) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump database\_cleaner from 1.8.4 to 1.8.5 [\#546](https://github.com/DEFRA/waste-exemptions-back-office/pull/546) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `71488f4` to `3c79bb3` [\#545](https://github.com/DEFRA/waste-exemptions-back-office/pull/545) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Don't expire VCR cassettes [\#544](https://github.com/DEFRA/waste-exemptions-back-office/pull/544) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_exemptions\_engine from `a9cde03` to `71488f4` [\#543](https://github.com/DEFRA/waste-exemptions-back-office/pull/543) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump factory\_bot\_rails from 5.1.1 to 5.2.0 [\#542](https://github.com/DEFRA/waste-exemptions-back-office/pull/542) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `2c75ba0` to `a9cde03` [\#541](https://github.com/DEFRA/waste-exemptions-back-office/pull/541) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Use multiple rubocop formats in Travis build [\#540](https://github.com/DEFRA/waste-exemptions-back-office/pull/540) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump defra\_ruby\_style from 0.1.4 to 0.2.1 [\#539](https://github.com/DEFRA/waste-exemptions-back-office/pull/539) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `6677f93` to `2c75ba0` [\#537](https://github.com/DEFRA/waste-exemptions-back-office/pull/537) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Refresh VCR cassettes [\#536](https://github.com/DEFRA/waste-exemptions-back-office/pull/536) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_exemptions\_engine from `0b1aad4` to `6677f93` [\#534](https://github.com/DEFRA/waste-exemptions-back-office/pull/534) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump github\_changelog\_generator from 1.15.1 to 1.15.2 [\#533](https://github.com/DEFRA/waste-exemptions-back-office/pull/533) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `374e9df` to `0b1aad4` [\#532](https://github.com/DEFRA/waste-exemptions-back-office/pull/532) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update VCR cassettes [\#531](https://github.com/DEFRA/waste-exemptions-back-office/pull/531) ([irisfaraway](https://github.com/irisfaraway))
- Bump database\_cleaner from 1.8.3 to 1.8.4 [\#530](https://github.com/DEFRA/waste-exemptions-back-office/pull/530) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump github\_changelog\_generator from 1.15.0 to 1.15.1 [\#529](https://github.com/DEFRA/waste-exemptions-back-office/pull/529) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `f84d7cd` to `374e9df` [\#528](https://github.com/DEFRA/waste-exemptions-back-office/pull/528) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump pry-byebug from 3.8.0 to 3.9.0 [\#527](https://github.com/DEFRA/waste-exemptions-back-office/pull/527) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `d40c8a2` to `f84d7cd` [\#526](https://github.com/DEFRA/waste-exemptions-back-office/pull/526) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `5ccf5d9` to `d40c8a2` [\#525](https://github.com/DEFRA/waste-exemptions-back-office/pull/525) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rubyzip from 2.2.0 to 2.3.0 [\#524](https://github.com/DEFRA/waste-exemptions-back-office/pull/524) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `4a2aaad` to `5ccf5d9` [\#523](https://github.com/DEFRA/waste-exemptions-back-office/pull/523) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.8.2 to 3.8.3 [\#522](https://github.com/DEFRA/waste-exemptions-back-office/pull/522) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `f5c7986` to `4a2aaad` [\#521](https://github.com/DEFRA/waste-exemptions-back-office/pull/521) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update VCR cassettes [\#520](https://github.com/DEFRA/waste-exemptions-back-office/pull/520) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump rspec-rails from 3.9.0 to 3.9.1 [\#519](https://github.com/DEFRA/waste-exemptions-back-office/pull/519) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `dbcf25f` to `f5c7986` [\#518](https://github.com/DEFRA/waste-exemptions-back-office/pull/518) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `af6969f` to `dbcf25f` [\#517](https://github.com/DEFRA/waste-exemptions-back-office/pull/517) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Switch to SonarCloud from CodeClimate [\#516](https://github.com/DEFRA/waste-exemptions-back-office/pull/516) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `870ee40` to `af6969f` [\#515](https://github.com/DEFRA/waste-exemptions-back-office/pull/515) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update VCR cassettes [\#514](https://github.com/DEFRA/waste-exemptions-back-office/pull/514) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_exemptions\_engine from `63ccd82` to `870ee40` [\#513](https://github.com/DEFRA/waste-exemptions-back-office/pull/513) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `5920cc9` to `63ccd82` [\#512](https://github.com/DEFRA/waste-exemptions-back-office/pull/512) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `542a9a9` to `5920cc9` [\#511](https://github.com/DEFRA/waste-exemptions-back-office/pull/511) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `b6d67c0` to `542a9a9` [\#510](https://github.com/DEFRA/waste-exemptions-back-office/pull/510) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump database\_cleaner from 1.8.2 to 1.8.3 [\#509](https://github.com/DEFRA/waste-exemptions-back-office/pull/509) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `9b0861a` to `b6d67c0` [\#508](https://github.com/DEFRA/waste-exemptions-back-office/pull/508) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.3.1](https://github.com/defra/waste-exemptions-back-office/tree/v1.3.1) (2020-02-13)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v1.3.0...v1.3.1)

**Implemented enhancements:**

- Exclude NCCC postcodes from automated renewal process [\#455](https://github.com/DEFRA/waste-exemptions-back-office/pull/455) ([irisfaraway](https://github.com/irisfaraway))

**Fixed bugs:**

- Make sure boxi export always have a value for person\_type [\#480](https://github.com/DEFRA/waste-exemptions-back-office/pull/480) ([cintamani](https://github.com/cintamani))

**Security fixes:**

- \[Security\] Bump secure\_headers from 5.1.0 to 5.2.0 [\#483](https://github.com/DEFRA/waste-exemptions-back-office/pull/483) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- \[Security\] Bump rack from 1.6.11 to 1.6.12 [\#472](https://github.com/DEFRA/waste-exemptions-back-office/pull/472) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- \[Security\] Bump loofah from 2.3.0 to 2.3.1 [\#453](https://github.com/DEFRA/waste-exemptions-back-office/pull/453) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

**Merged pull requests:**

- Bump waste\_exemptions\_engine from `58a0528` to `9b0861a` [\#507](https://github.com/DEFRA/waste-exemptions-back-office/pull/507) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.8.1 to 3.8.2 [\#506](https://github.com/DEFRA/waste-exemptions-back-office/pull/506) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `c9dfc99` to `58a0528` [\#505](https://github.com/DEFRA/waste-exemptions-back-office/pull/505) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update VCR cassettes [\#504](https://github.com/DEFRA/waste-exemptions-back-office/pull/504) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_exemptions\_engine from `49f5ec7` to `c9dfc99` [\#503](https://github.com/DEFRA/waste-exemptions-back-office/pull/503) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.8.0 to 3.8.1 [\#502](https://github.com/DEFRA/waste-exemptions-back-office/pull/502) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump vcr from 5.0.0 to 5.1.0 [\#501](https://github.com/DEFRA/waste-exemptions-back-office/pull/501) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Switch airbrake mgmt to defra-ruby-alert [\#500](https://github.com/DEFRA/waste-exemptions-back-office/pull/500) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `cf81d60` to `5c52bb0` [\#499](https://github.com/DEFRA/waste-exemptions-back-office/pull/499) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `3b03923` to `cf81d60` [\#498](https://github.com/DEFRA/waste-exemptions-back-office/pull/498) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rubyzip from 2.1.0 to 2.2.0 [\#497](https://github.com/DEFRA/waste-exemptions-back-office/pull/497) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump database\_cleaner from 1.8.1 to 1.8.2 [\#495](https://github.com/DEFRA/waste-exemptions-back-office/pull/495) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump kaminari from 1.1.1 to 1.2.0 [\#494](https://github.com/DEFRA/waste-exemptions-back-office/pull/494) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump database\_cleaner from 1.7.0 to 1.8.1 [\#493](https://github.com/DEFRA/waste-exemptions-back-office/pull/493) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_style from 0.1.3 to 0.1.4 [\#492](https://github.com/DEFRA/waste-exemptions-back-office/pull/492) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `e8d5ac4` to `3b03923` [\#491](https://github.com/DEFRA/waste-exemptions-back-office/pull/491) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Fix changelog generator [\#490](https://github.com/DEFRA/waste-exemptions-back-office/pull/490) ([Cruikshanks](https://github.com/Cruikshanks))
- Temp. fix for cc-test-reporter & SimpleCov 0.18 [\#489](https://github.com/DEFRA/waste-exemptions-back-office/pull/489) ([Cruikshanks](https://github.com/Cruikshanks))
- Update VCR cassettes [\#487](https://github.com/DEFRA/waste-exemptions-back-office/pull/487) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump rubyzip from 2.0.0 to 2.1.0 [\#485](https://github.com/DEFRA/waste-exemptions-back-office/pull/485) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump pry-byebug from 3.7.0 to 3.8.0 [\#484](https://github.com/DEFRA/waste-exemptions-back-office/pull/484) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump secure\_headers from 5.0.5 to 5.1.0 [\#482](https://github.com/DEFRA/waste-exemptions-back-office/pull/482) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `e0e4a7d` to `e8d5ac4` [\#481](https://github.com/DEFRA/waste-exemptions-back-office/pull/481) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.7.6 to 3.8.0 [\#479](https://github.com/DEFRA/waste-exemptions-back-office/pull/479) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `46eeeeb` to `e0e4a7d` [\#478](https://github.com/DEFRA/waste-exemptions-back-office/pull/478) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update VCR cassettes [\#477](https://github.com/DEFRA/waste-exemptions-back-office/pull/477) ([irisfaraway](https://github.com/irisfaraway))
- Update VCR test cassettes [\#476](https://github.com/DEFRA/waste-exemptions-back-office/pull/476) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `a866f74` to `46eeeeb` [\#475](https://github.com/DEFRA/waste-exemptions-back-office/pull/475) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `b67ac0f` to `a866f74` [\#473](https://github.com/DEFRA/waste-exemptions-back-office/pull/473) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `b5da681` to `b67ac0f` [\#471](https://github.com/DEFRA/waste-exemptions-back-office/pull/471) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update VCR cassettes [\#470](https://github.com/DEFRA/waste-exemptions-back-office/pull/470) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_exemptions\_engine from `bede82c` to `b5da681` [\#469](https://github.com/DEFRA/waste-exemptions-back-office/pull/469) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `16c3e12` to `bede82c` [\#468](https://github.com/DEFRA/waste-exemptions-back-office/pull/468) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `d14b8b4` to `16c3e12` [\#467](https://github.com/DEFRA/waste-exemptions-back-office/pull/467) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update VCR cassettes [\#466](https://github.com/DEFRA/waste-exemptions-back-office/pull/466) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_exemptions\_engine from `cd10b79` to `d14b8b4` [\#465](https://github.com/DEFRA/waste-exemptions-back-office/pull/465) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update VCR cassettes [\#464](https://github.com/DEFRA/waste-exemptions-back-office/pull/464) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `88227a2` to `cd10b79` [\#463](https://github.com/DEFRA/waste-exemptions-back-office/pull/463) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `9dda9af` to `88227a2` [\#462](https://github.com/DEFRA/waste-exemptions-back-office/pull/462) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `11c34c0` to `9dda9af` [\#461](https://github.com/DEFRA/waste-exemptions-back-office/pull/461) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `65dc03d` to `11c34c0` [\#460](https://github.com/DEFRA/waste-exemptions-back-office/pull/460) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update address base url details [\#459](https://github.com/DEFRA/waste-exemptions-back-office/pull/459) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `0248ed7` to `65dc03d` [\#458](https://github.com/DEFRA/waste-exemptions-back-office/pull/458) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump github\_changelog\_generator from 1.14.3 to 1.15.0 [\#456](https://github.com/DEFRA/waste-exemptions-back-office/pull/456) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `832909b` to `0248ed7` [\#454](https://github.com/DEFRA/waste-exemptions-back-office/pull/454) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.3.0](https://github.com/defra/waste-exemptions-back-office/tree/v1.3.0) (2019-10-22)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v1.2.1...v1.3.0)

**Implemented enhancements:**

- Add lookup job for X and Y updates on addresses [\#421](https://github.com/DEFRA/waste-exemptions-back-office/pull/421) ([cintamani](https://github.com/cintamani))
- Add area lookup for addresses task [\#415](https://github.com/DEFRA/waste-exemptions-back-office/pull/415) ([cintamani](https://github.com/cintamani))
- Add visually hidden text for button [\#410](https://github.com/DEFRA/waste-exemptions-back-office/pull/410) ([cintamani](https://github.com/cintamani))
- Add ordering to bulk AD renewal letters [\#406](https://github.com/DEFRA/waste-exemptions-back-office/pull/406) ([cintamani](https://github.com/cintamani))
- Fix various minor issues on AD letters [\#402](https://github.com/DEFRA/waste-exemptions-back-office/pull/402) ([cintamani](https://github.com/cintamani))
- Clean old AD renewal letters files [\#400](https://github.com/DEFRA/waste-exemptions-back-office/pull/400) ([cintamani](https://github.com/cintamani))
- Schedule export AD renewal letters [\#390](https://github.com/DEFRA/waste-exemptions-back-office/pull/390) ([cintamani](https://github.com/cintamani))
- Add dashboard view to AD letters [\#389](https://github.com/DEFRA/waste-exemptions-back-office/pull/389) ([cintamani](https://github.com/cintamani))
- Ad renewal letters - Create record first [\#386](https://github.com/DEFRA/waste-exemptions-back-office/pull/386) ([cintamani](https://github.com/cintamani))
- Update env.example [\#384](https://github.com/DEFRA/waste-exemptions-back-office/pull/384) ([cintamani](https://github.com/cintamani))
- AD renewal letters bulk generation [\#383](https://github.com/DEFRA/waste-exemptions-back-office/pull/383) ([cintamani](https://github.com/cintamani))

**Fixed bugs:**

- Add with\_postcode to x & y lookup job scope [\#436](https://github.com/DEFRA/waste-exemptions-back-office/pull/436) ([Cruikshanks](https://github.com/Cruikshanks))
- Restrict missing area update job to site addresses [\#426](https://github.com/DEFRA/waste-exemptions-back-office/pull/426) ([Cruikshanks](https://github.com/Cruikshanks))
- Order exemptions correctly in the generated AD renewal letters [\#408](https://github.com/DEFRA/waste-exemptions-back-office/pull/408) ([cintamani](https://github.com/cintamani))
- Various fixes to AD letters [\#407](https://github.com/DEFRA/waste-exemptions-back-office/pull/407) ([cintamani](https://github.com/cintamani))
- Fix bug on Cleaning AD renewal letters [\#405](https://github.com/DEFRA/waste-exemptions-back-office/pull/405) ([cintamani](https://github.com/cintamani))
- Cast string to integer [\#397](https://github.com/DEFRA/waste-exemptions-back-office/pull/397) ([cintamani](https://github.com/cintamani))

**Merged pull requests:**

- Bump waste\_exemptions\_engine from `93151e1` to `832909b` [\#452](https://github.com/DEFRA/waste-exemptions-back-office/pull/452) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `4b2ad6a` to `93151e1` [\#451](https://github.com/DEFRA/waste-exemptions-back-office/pull/451) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `2599db2` to `4b2ad6a` [\#450](https://github.com/DEFRA/waste-exemptions-back-office/pull/450) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update lookup rake tasks to use new engine services [\#447](https://github.com/DEFRA/waste-exemptions-back-office/pull/447) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump rspec-rails from 3.8.2 to 3.9.0 [\#444](https://github.com/DEFRA/waste-exemptions-back-office/pull/444) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Fix travis link in README [\#443](https://github.com/DEFRA/waste-exemptions-back-office/pull/443) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `06b2df3` to `18c256d` [\#442](https://github.com/DEFRA/waste-exemptions-back-office/pull/442) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `91374c1` to `06b2df3` [\#441](https://github.com/DEFRA/waste-exemptions-back-office/pull/441) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `83e9ba3` to `91374c1` [\#440](https://github.com/DEFRA/waste-exemptions-back-office/pull/440) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump factory\_bot\_rails from 5.1.0 to 5.1.1 [\#439](https://github.com/DEFRA/waste-exemptions-back-office/pull/439) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `5b157fa` to `83e9ba3` [\#438](https://github.com/DEFRA/waste-exemptions-back-office/pull/438) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `9eb2f41` to `5b157fa` [\#435](https://github.com/DEFRA/waste-exemptions-back-office/pull/435) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_style from 0.1.2 to 0.1.3 [\#434](https://github.com/DEFRA/waste-exemptions-back-office/pull/434) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `aafc348` to `9eb2f41` [\#433](https://github.com/DEFRA/waste-exemptions-back-office/pull/433) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `cbf8608` to `aafc348` [\#432](https://github.com/DEFRA/waste-exemptions-back-office/pull/432) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.7.5 to 3.7.6 [\#431](https://github.com/DEFRA/waste-exemptions-back-office/pull/431) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update schedule.rb order by runtime [\#430](https://github.com/DEFRA/waste-exemptions-back-office/pull/430) ([Cruikshanks](https://github.com/Cruikshanks))
- Add support for rake integration tests [\#429](https://github.com/DEFRA/waste-exemptions-back-office/pull/429) ([Cruikshanks](https://github.com/Cruikshanks))
- Remove dependence on env vars for some tests [\#428](https://github.com/DEFRA/waste-exemptions-back-office/pull/428) ([Cruikshanks](https://github.com/Cruikshanks))
- Housekeeping on the env vars [\#427](https://github.com/DEFRA/waste-exemptions-back-office/pull/427) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `869fb2a` to `cbf8608` [\#425](https://github.com/DEFRA/waste-exemptions-back-office/pull/425) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rubyzip from 1.2.4 to 2.0.0 [\#423](https://github.com/DEFRA/waste-exemptions-back-office/pull/423) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump uglifier from 4.1.20 to 4.2.0 [\#422](https://github.com/DEFRA/waste-exemptions-back-office/pull/422) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `53a145d` to `869fb2a` [\#420](https://github.com/DEFRA/waste-exemptions-back-office/pull/420) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `3041aa6` to `53a145d` [\#419](https://github.com/DEFRA/waste-exemptions-back-office/pull/419) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `251f52c` to `3041aa6` [\#418](https://github.com/DEFRA/waste-exemptions-back-office/pull/418) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Add comment in regard of design needed in 2 pages [\#417](https://github.com/DEFRA/waste-exemptions-back-office/pull/417) ([cintamani](https://github.com/cintamani))
- Bump factory\_bot\_rails from 5.0.2 to 5.1.0 [\#416](https://github.com/DEFRA/waste-exemptions-back-office/pull/416) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Handle nil letters on AD letter export [\#414](https://github.com/DEFRA/waste-exemptions-back-office/pull/414) ([andrewhick](https://github.com/andrewhick))
- Bump waste\_exemptions\_engine from `3f83cb1` to `251f52c` [\#413](https://github.com/DEFRA/waste-exemptions-back-office/pull/413) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `331d5ba` to `3f83cb1` [\#411](https://github.com/DEFRA/waste-exemptions-back-office/pull/411) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `371066e` to `331d5ba` [\#409](https://github.com/DEFRA/waste-exemptions-back-office/pull/409) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump turbolinks from 5.2.0 to 5.2.1 [\#404](https://github.com/DEFRA/waste-exemptions-back-office/pull/404) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Switch source of defra\_ruby\_aws to rubygems [\#403](https://github.com/DEFRA/waste-exemptions-back-office/pull/403) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `d29f983` to `371066e` [\#401](https://github.com/DEFRA/waste-exemptions-back-office/pull/401) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.7.4 to 3.7.5 [\#398](https://github.com/DEFRA/waste-exemptions-back-office/pull/398) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_aws from `6c3b832` to `ce82b42` [\#396](https://github.com/DEFRA/waste-exemptions-back-office/pull/396) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.7.3 to 3.7.4 [\#395](https://github.com/DEFRA/waste-exemptions-back-office/pull/395) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump simplecov from 0.17.0 to 0.17.1 [\#394](https://github.com/DEFRA/waste-exemptions-back-office/pull/394) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `2927abd` to `d29f983` [\#393](https://github.com/DEFRA/waste-exemptions-back-office/pull/393) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `95782a6` to `2927abd` [\#392](https://github.com/DEFRA/waste-exemptions-back-office/pull/392) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.7.2 to 3.7.3 [\#391](https://github.com/DEFRA/waste-exemptions-back-office/pull/391) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Rename :generate namespace to :export [\#388](https://github.com/DEFRA/waste-exemptions-back-office/pull/388) ([cintamani](https://github.com/cintamani))
- Bump waste\_exemptions\_engine from `4952466` to `95782a6` [\#385](https://github.com/DEFRA/waste-exemptions-back-office/pull/385) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.2.1](https://github.com/defra/waste-exemptions-back-office/tree/v1.2.1) (2019-09-10)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v1.2.0...v1.2.1)

**Merged pull requests:**

- Bump waste\_exemptions\_engine from `b337756` to `4952466` [\#382](https://github.com/DEFRA/waste-exemptions-back-office/pull/382) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update project following name change [\#381](https://github.com/DEFRA/waste-exemptions-back-office/pull/381) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump devise from 4.7.0 to 4.7.1 [\#380](https://github.com/DEFRA/waste-exemptions-back-office/pull/380) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rubyzip from 1.2.3 to 1.2.4 [\#379](https://github.com/DEFRA/waste-exemptions-back-office/pull/379) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `0b5d7dc` to `b337756` [\#378](https://github.com/DEFRA/waste-exemptions-back-office/pull/378) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.2.0](https://github.com/defra/waste-exemptions-back-office/tree/v1.2.0) (2019-09-06)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v1.1.1...v1.2.0)

**Implemented enhancements:**

- Add link to view renewal letter [\#371](https://github.com/DEFRA/waste-exemptions-back-office/pull/371) ([irisfaraway](https://github.com/irisfaraway))
- Generate assisted digital renewal letter [\#357](https://github.com/DEFRA/waste-exemptions-back-office/pull/357) ([irisfaraway](https://github.com/irisfaraway))
- Add link to renewed from registration in details page [\#356](https://github.com/DEFRA/waste-exemptions-back-office/pull/356) ([cintamani](https://github.com/cintamani))
- Show an already renewed message when relevant [\#355](https://github.com/DEFRA/waste-exemptions-back-office/pull/355) ([cintamani](https://github.com/cintamani))
- Schedule transient registration cleanup task [\#352](https://github.com/DEFRA/waste-exemptions-back-office/pull/352) ([irisfaraway](https://github.com/irisfaraway))
- Add rake task to remove old transient\_registrations [\#350](https://github.com/DEFRA/waste-exemptions-back-office/pull/350) ([irisfaraway](https://github.com/irisfaraway))

**Fixed bugs:**

- Don't include ceased/revoked exemptions in 'unlisted exemptions' count [\#375](https://github.com/DEFRA/waste-exemptions-back-office/pull/375) ([irisfaraway](https://github.com/irisfaraway))
- Don't list revoked and ceased exemptions in renewal letter [\#374](https://github.com/DEFRA/waste-exemptions-back-office/pull/374) ([irisfaraway](https://github.com/irisfaraway))
- Make the cutoff for cleaning out old records start of day [\#364](https://github.com/DEFRA/waste-exemptions-back-office/pull/364) ([irisfaraway](https://github.com/irisfaraway))
- Fix cleanup:transient\_registrations rake task [\#353](https://github.com/DEFRA/waste-exemptions-back-office/pull/353) ([irisfaraway](https://github.com/irisfaraway))

**Merged pull requests:**

- Bump waste\_exemptions\_engine from `4931c96` to `0b5d7dc` [\#377](https://github.com/DEFRA/waste-exemptions-back-office/pull/377) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.7.1 to 3.7.2 [\#376](https://github.com/DEFRA/waste-exemptions-back-office/pull/376) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `797fa72` to `4931c96` [\#373](https://github.com/DEFRA/waste-exemptions-back-office/pull/373) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `76d5061` to `797fa72` [\#372](https://github.com/DEFRA/waste-exemptions-back-office/pull/372) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.7.0 to 3.7.1 [\#370](https://github.com/DEFRA/waste-exemptions-back-office/pull/370) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `0016569` to `76d5061` [\#369](https://github.com/DEFRA/waste-exemptions-back-office/pull/369) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `372065c` to `0016569` [\#368](https://github.com/DEFRA/waste-exemptions-back-office/pull/368) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `cdc5a32` to `372065c` [\#367](https://github.com/DEFRA/waste-exemptions-back-office/pull/367) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `97d10b8` to `cdc5a32` [\#366](https://github.com/DEFRA/waste-exemptions-back-office/pull/366) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `238f232` to `97d10b8` [\#365](https://github.com/DEFRA/waste-exemptions-back-office/pull/365) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `6a9e6ce` to `238f232` [\#363](https://github.com/DEFRA/waste-exemptions-back-office/pull/363) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `9276966` to `6a9e6ce` [\#362](https://github.com/DEFRA/waste-exemptions-back-office/pull/362) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `0e54dae` to `0d52b0b` [\#359](https://github.com/DEFRA/waste-exemptions-back-office/pull/359) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.6.2 to 3.7.0 [\#358](https://github.com/DEFRA/waste-exemptions-back-office/pull/358) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `1d88d40` to `0e54dae` [\#354](https://github.com/DEFRA/waste-exemptions-back-office/pull/354) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `7e177e9` to `1d88d40` [\#351](https://github.com/DEFRA/waste-exemptions-back-office/pull/351) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Make the registration responsible to know if it is renewable [\#349](https://github.com/DEFRA/waste-exemptions-back-office/pull/349) ([cintamani](https://github.com/cintamani))
- Bump waste\_exemptions\_engine from `241bfc6` to `7e177e9` [\#348](https://github.com/DEFRA/waste-exemptions-back-office/pull/348) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.1.1](https://github.com/defra/waste-exemptions-back-office/tree/v1.1.1) (2019-08-20)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v1.1.0...v1.1.1)

**Implemented enhancements:**

- Include expired exemptions in renewal emails [\#343](https://github.com/DEFRA/waste-exemptions-back-office/pull/343) ([irisfaraway](https://github.com/irisfaraway))

**Fixed bugs:**

- Do not open renewals in new tab [\#347](https://github.com/DEFRA/waste-exemptions-back-office/pull/347) ([Cruikshanks](https://github.com/Cruikshanks))
- Don't require active status to display renewal link [\#342](https://github.com/DEFRA/waste-exemptions-back-office/pull/342) ([irisfaraway](https://github.com/irisfaraway))

**Merged pull requests:**

- Bump waste\_exemptions\_engine from `bc6829e` to `241bfc6` [\#346](https://github.com/DEFRA/waste-exemptions-back-office/pull/346) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump devise from 4.6.2 to 4.7.0 [\#345](https://github.com/DEFRA/waste-exemptions-back-office/pull/345) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `2280501` to `bc6829e` [\#344](https://github.com/DEFRA/waste-exemptions-back-office/pull/344) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `6c28b06` to `2280501` [\#341](https://github.com/DEFRA/waste-exemptions-back-office/pull/341) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `273873f` to `6c28b06` [\#340](https://github.com/DEFRA/waste-exemptions-back-office/pull/340) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `412bfcb` to `273873f` [\#339](https://github.com/DEFRA/waste-exemptions-back-office/pull/339) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.1.0](https://github.com/defra/waste-exemptions-back-office/tree/v1.1.0) (2019-08-15)

[Full Changelog](https://github.com/defra/waste-exemptions-back-office/compare/v1.0.2...v1.1.0)

**Implemented enhancements:**

- Do not show renew links on not active registrations [\#336](https://github.com/DEFRA/waste-exemptions-back-office/pull/336) ([cintamani](https://github.com/cintamani))
- Add links to resend renew email in back office [\#335](https://github.com/DEFRA/waste-exemptions-back-office/pull/335) ([cintamani](https://github.com/cintamani))
- Add second email reminder for renewals [\#332](https://github.com/DEFRA/waste-exemptions-back-office/pull/332) ([cintamani](https://github.com/cintamani))
- Update magic link email text [\#326](https://github.com/DEFRA/waste-exemptions-back-office/pull/326) ([irisfaraway](https://github.com/irisfaraway))
- Add anonymise emails rake task [\#324](https://github.com/DEFRA/waste-exemptions-back-office/pull/324) ([cintamani](https://github.com/cintamani))
- Tell search engines not to index app [\#322](https://github.com/DEFRA/waste-exemptions-back-office/pull/322) ([irisfaraway](https://github.com/irisfaraway))
- Add renew link in resource details page [\#318](https://github.com/DEFRA/waste-exemptions-back-office/pull/318) ([cintamani](https://github.com/cintamani))
- Add renew link in back office dashboard [\#316](https://github.com/DEFRA/waste-exemptions-back-office/pull/316) ([cintamani](https://github.com/cintamani))
- Update schema [\#311](https://github.com/DEFRA/waste-exemptions-back-office/pull/311) ([cintamani](https://github.com/cintamani))
- Add EA logo to renew email [\#308](https://github.com/DEFRA/waste-exemptions-back-office/pull/308) ([Cruikshanks](https://github.com/Cruikshanks))
- Use ENV variable to setup magic link feature toggle [\#306](https://github.com/DEFRA/waste-exemptions-back-office/pull/306) ([cintamani](https://github.com/cintamani))
- Update schema - Drop reference index on transient registrations [\#300](https://github.com/DEFRA/waste-exemptions-back-office/pull/300) ([cintamani](https://github.com/cintamani))
- Add schema changes [\#298](https://github.com/DEFRA/waste-exemptions-back-office/pull/298) ([cintamani](https://github.com/cintamani))
- Add configs for generating and decoding a renew JWT token [\#293](https://github.com/DEFRA/waste-exemptions-back-office/pull/293) ([cintamani](https://github.com/cintamani))
- Activate first email reminder feature [\#281](https://github.com/DEFRA/waste-exemptions-back-office/pull/281) ([cintamani](https://github.com/cintamani))

**Fixed bugs:**

- Add ability to custom-parse attribute on Boxi serializer [\#327](https://github.com/DEFRA/waste-exemptions-back-office/pull/327) ([cintamani](https://github.com/cintamani))
- Close Airbrake to execute async promises [\#286](https://github.com/DEFRA/waste-exemptions-back-office/pull/286) ([cintamani](https://github.com/cintamani))

**Security fixes:**

- \[Security\] Bump nokogiri from 1.10.3 to 1.10.4 [\#330](https://github.com/DEFRA/waste-exemptions-back-office/pull/330) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

**Merged pull requests:**

- Bump waste\_exemptions\_engine from `83ebb42` to `412bfcb` [\#338](https://github.com/DEFRA/waste-exemptions-back-office/pull/338) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `f6790cf` to `83ebb42` [\#337](https://github.com/DEFRA/waste-exemptions-back-office/pull/337) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Refactor email reminders to remove non-magic link [\#334](https://github.com/DEFRA/waste-exemptions-back-office/pull/334) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_exemptions\_engine from `3af5382` to `f6790cf` [\#333](https://github.com/DEFRA/waste-exemptions-back-office/pull/333) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `c2514d6` to `3af5382` [\#331](https://github.com/DEFRA/waste-exemptions-back-office/pull/331) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `10a8898` to `c2514d6` [\#329](https://github.com/DEFRA/waste-exemptions-back-office/pull/329) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `108b701` to `10a8898` [\#328](https://github.com/DEFRA/waste-exemptions-back-office/pull/328) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `c297a7c` to `108b701` [\#321](https://github.com/DEFRA/waste-exemptions-back-office/pull/321) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `0eae8ad` to `c297a7c` [\#320](https://github.com/DEFRA/waste-exemptions-back-office/pull/320) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `445de3a` to `0eae8ad` [\#319](https://github.com/DEFRA/waste-exemptions-back-office/pull/319) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `08c530d` to `445de3a` [\#315](https://github.com/DEFRA/waste-exemptions-back-office/pull/315) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_exemptions\_engine from `dea555c` to `08c530d` [\#314](https://github.com/DEFRA/waste-exemptions-back-office/pull/314) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
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
