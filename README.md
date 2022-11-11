# Jarkom-Modul-3-D14-2022

Lapres Praktikum Jarkom Modul 3

| Nama                      | NRP      |
|---------------------------|----------|
|Gloriyano C. Daniel Pepuho |5025201121|

![Topology](topology.png)

## Cara Pengerjaan

### Nomor 1 & 2
Loid bersama Franky berencana membuat peta tersebut dengan kriteria WISE sebagai DNS Server, Westalis sebagai DHCP Server, Berlint sebagai Proxy Server, dan Ostania sebagai DHCP Relay . Loid dan Franky menyusun peta tersebut dengan hati-hati dan teliti.

Pertama **Konfigurasi IP Address terlebih dahulu**

* Ostania (DHCP Relay)
```

auto eth0
iface eth0 inet static
	address 192.168.122.222
	netmask 255.255.255.0
	gateway 192.168.122.1

auto eth1
iface eth1 inet static
	address 192.192.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.192.2.1
	netmask 255.255.255.0


auto eth3
iface eth3 inet static
	address 192.192.3.1
	netmask 255.255.255.0

```

* Westalis (DHCP Server)

```

auto eth0
iface eth0 inet static
	address 192.192.2.3
	netmask 255.255.255.0
	gateway 192.192.2.1

```

* Wise (DNS Server)

```

auto eth0
iface eth0 inet static
	address 192.192.2.2
	netmask 255.255.255.0
	gateway 192.192.2.1

```

* Berlint (Proxy Server)

```
auto eth0
iface eth0 inet static
	address 192.192.2.4
	netmask 255.255.255.0
	gateway 192.192.2.1


```