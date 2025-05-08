#!/bin/bash

# Fonction pour générer les fichiers .startup pour chaque machine
generate_startup() {
    local machine=$1
    local ip=$2
    local netmask=$3
    local gateway=$4

    # Créer le fichier machine.startup
    echo "#!/bin/bash" > ${machine}.startup
    echo "echo 'Démarrage de ${machine} avec IP: ${ip}'" >> ${machine}.startup
    echo "ip addr add ${ip}/${netmask} dev eth0" >> ${machine}.startup

    if [ -n "$gateway" ]; then
        echo "ip route add default via ${gateway}" >> ${machine}.startup
    fi
}

# Générer les fichiers .startup pour chaque machine
generate_startup "s_web" "172.16.192.1" "22" ""
generate_startup "s_admin" "172.16.192.2" "22" ""
generate_startup "s_demo" "172.16.192.3" "22" ""
generate_startup "sf" "172.16.192.4" "22" ""

generate_startup "pca" "172.16.196.1" "24" "172.16.196.3"
generate_startup "pcb" "172.16.196.2" "24" "172.16.196.3"

generate_startup "r_p" "172.16.196.3" "24" "172.16.196.1"

generate_startup "pcc" "172.16.197.1" "22" "172.16.200.1"
generate_startup "pcd" "172.16.197.2" "22" "172.16.200.1"

generate_startup "r_c" "172.16.200.1" "24" "172.16.197.1"

generate_startup "r_d" "172.16.201.1" "24" "172.16.201.254"

# Pour les serveurs DHCP sur R_C
echo "# Configuration du serveur DHCP sur R_C" >> r_c.startup
echo "dhcpd -lf /var/lib/dhcp/dhcpd.leases -s 172.16.197.1 -p 67" >> r_c.startup
