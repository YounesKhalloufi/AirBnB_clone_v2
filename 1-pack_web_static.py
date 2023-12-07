#!/usr/bin/python3
"""
A Fabric script that generates a .tgz archive from the contents
of the web_static folder of your AirBnB Clone repo,
using the function do_pack.
"""
from fabric.api import local
from datetime import datetime
import os

def do_pack():
    try:
        # Create the 'versions' directory if it doesn't exist
        if not os.path.exists("versions"):
            os.mkdir("versions")

        # Generate the name for the archive
        current_time = datetime.now()
        archive_name = "web_static_{}{}{}{}{}{}.tgz".format(
            current_time.year,
            current_time.month,
            current_time.day,
            current_time.hour,
            current_time.minute,
            current_time.second
        )

        # Create the .tgz archive using tar
        print("Packing web_static to versions/{}".format(archive_name))
        local(
            "tar -cvzf versions/{} web_static".format(archive_name),
            capture=False
        )

        archive_path = "versions/{}".format(archive_name)

        # Check if the archive was created successfully
        if os.path.exists(archive_path):
            archive_size = os.path.getsize(archive_path)
            print("web_static packed: {} -> {}Bytes".format(archive_path, archive_size))
            return archive_path
        else:
            return None
    except Exception as e:
        return None

# Test the function
if __name__ == "__main__":
    result = do_pack()
    if result:
        print("Archive created:", result)
    else:
        print("Failed to create archive.")
