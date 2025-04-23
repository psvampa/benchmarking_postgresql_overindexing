# postgresql_benchmarking_overindexing
This repository contains a collection of scripts for designing, populating, and benchmarking a custom PostgreSQL schema using pgbench.
The goal is to simulate a pseudo-realistic workload (something different from what pgbench does by using thin tables full of integers) and assess the performance impact of overindexing in a controlled and repeatable environment.

## Benchmark environment specs

### Hardware specs
```bash
$ sudo dmidecode -s system-manufacturer
Dell Inc.
$
$ sudo dmidecode -s system-product-name
PowerEdge C6525
$
$ lscpu | awk '
/^Architecture:/ {show1=18; print; next}
show1 > 0 {print; show1--; next}
/^[Ll][123][a-z]* cache:/ {print}
'
Architecture:                       x86_64
CPU op-mode(s):                     32-bit, 64-bit
Address sizes:                      43 bits physical, 48 bits virtual
Byte Order:                         Little Endian
CPU(s):                             128
On-line CPU(s) list:                0-127
Vendor ID:                          AuthenticAMD
Model name:                         AMD EPYC 7452 32-Core Processor
CPU family:                         23
Model:                              49
Thread(s) per core:                 2
Core(s) per socket:                 32
Socket(s):                          2
Stepping:                           0
Frequency boost:                    enabled
CPU(s) scaling MHz:                 100%
CPU max MHz:                        2350.0000
CPU min MHz:                        1500.0000
BogoMIPS:                           4691.24
L1d cache:                          2 MiB (64 instances)
L1i cache:                          2 MiB (64 instances)
L2 cache:                           32 MiB (64 instances)
L3 cache:                           256 MiB (16 instances)
$
$ sudo dmidecode --type memory | awk '
/^\s*Size:/ && $2 ~ /^[0-9]+$/ {
    total += $2
    count++
}
/^\s*Speed:/ { speed[$0]++ }
/^\s*Type:/ { type[$0]++ }
END {
    printf("Total memory: %.0f GB in %d modules\n\n", total, count)
    print "=== Memory types ==="
    for (t in type) print type[t], "-", t
    print "\n=== Memory speeds ==="
    for (s in speed) print speed[s], "-", s
}
'
Total memory: 1024 GB in 16 modules

=== Memory types ===
16 -  Type: DDR4

=== Memory speeds ===
16 -  Speed: 3200 MT/s
$
```
### OS specs
```bash
$ hostnamectl | grep "Operating System"
Operating System: Oracle Linux Server 9.4
$
```
