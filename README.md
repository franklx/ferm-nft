The program [ferm](https://github.com/MaxKellermann/ferm) allows you to write a human-readable configuration, which is converted to iptables rules.

In Debian, iptables is being [replaced](https://wiki.debian.org/nftables#Should_I_replace_an_iptables_firewall_with_a_nftables_one.3F) by nftables.

Until iptables has been fully replaced by nftables, the `iptables` commands do not actually control iptables, but nftables:

```
root@sandbox:~# which iptables
/usr/sbin/iptables
root@sandbox:~# ls -l /usr/sbin/iptables
lrwxrwxrwx 1 root root 26 Jun 26  2021 /usr/sbin/iptables -> /etc/alternatives/iptables
root@sandbox:~# ls -l /etc/alternatives/iptables
lrwxrwxrwx 1 root root 22 Jun 26  2021 /etc/alternatives/iptables -> /usr/sbin/iptables-nft
```

This tool, `iptables-nft`, allows you to use nftables with iptables syntax. In this case, ferm generates the iptables syntax.

However, ferm no longer uses `iptables-nft`. Instead, in commit [47b78b6](https://github.com/MaxKellermann/ferm/commit/47b78b6), the use of legacy iptables (i.e. not nftables) was hardcoded. Using legacy iptables is deprecated and discouraged.

Starting from Debian Bullseye, ferm 2.5.1 is shipped in the default repositories, which contains this commit. In other words: when upgrading to Debian Bullseye with ferm, legacy iptables will be used, rather than nftables.

This repository holds a number of patches which revert this behaviour by adding the `--no-legacy` parameter. The resulting package can be retrieved from the following apt repository:

    deb https://apt.tuxis.nl/tuxis/ ferm main

To ensure that ferm is installed from this repository, copy `ferm.pref` to `/etc/apt/preferences.d/ferm.pref`.