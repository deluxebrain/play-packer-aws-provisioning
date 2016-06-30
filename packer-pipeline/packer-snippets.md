# Snippets of packer templates 

### Add in volumes to an AWS EC2 instance

```json
{
  "builders": [
    {
      "type": "amazon-ebs",
      "ami_block_device_mappings": [
        {
          "device_name": "/dev/sda1",
          "encrypted": false,
          "volume_size": 80,
          "volume_type": "gp2",
          "delete_on_termination": true
        },
        {
          "device_name": "xvdf",
          "encrypted": false,
          "volume_size": 20,
          "volume_type": "gp2",
          "delete_on_termination": true
        }
      ]
    }
  ]
}
```
