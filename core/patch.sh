#!/usr/bin/env bash

mkdir /opt/ipsframework-code
ln -s /opt/OAS /opt/ipsframework-code/install 

cd /opt
mkdir vibe-data
mkdir vibe-data/physics
mkdir vibe-data/physics/CharTran
mkdir vibe-data/physics/Thermal
mkdir vibe-data/physics/Electrical
mkdir vibe-data/physics/CharTran/ntg
mkdir vibe-data/physics/CharTran/ntg/bin
mkdir vibe-data/physics/Thermal/amperes
mkdir vibe-data/physics/Thermal/amperes/bin
mkdir vibe-data/physics/Electrical/amperes
mkdir vibe-data/physics/Electrical/amperes/bin
cp amperes/test/testThermalBattery vibe-data/physics/Thermal/amperes/bin/amperes
cp amperes/test/testNTGModel vibe-data/physics/CharTran/ntg/bin/ntg
cp amperes/test/testElectricalBattery vibe-data/physics/Electrical/amperes/bin/amperes

sed -i.old \
  -e 's|/home/batsim/caebat/vibe|/opt/vibe|' \
  -e 's|/home/batsim/caebat/data|/opt/vibe-data|' \
  /opt/vibe/examples/config/batsim.conf

# Update the path of CGNS_ROOT_DIR and HDF5_ROOT
sed -i 's|/home/batsim/caebat/install/opt/CGNS|/opt/CGNS|g' \
  /opt/vibe/components/config/makeconfig.batsim
sed -i 's|/home/batsim/caebat/install/opt/tpls/hdf5|/opt/tpls/hdf5|' \
  /opt/vibe/components/config/makeconfig.batsim
