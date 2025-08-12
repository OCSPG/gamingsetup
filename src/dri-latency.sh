#!/bin/bash

set -e

echo "Configuring DRI to reduce latency..."

# Create system-wide DRI configuration
sudo tee /etc/drirc > /dev/null << 'EOF'
<driconf>
   <device>
       <application name="Default">
           <option name="vblank_mode" value="0" />
       </application>
   </device>
</driconf>
EOF

echo "DRI latency configuration created at /etc/drirc"