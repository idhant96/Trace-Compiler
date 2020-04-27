from setuptools import setup, find_packages

with open("README.md", "r") as readme_file:
    readme = readme_file.read()

with open("requirements.txt") as req_file:
    requirements_str = req_file.read()

requirements_list = requirements_str.split('\n')

setup(
    name="trace",
    version="0.0.1",
    author="Idhant Haldankar",
    author_email="ihaldank@asu.edu",
    description="SER 502 Project",
    long_description=readme,
    long_description_content_type="text/markdown",
    url="https://github.com/akrish84/SER502-Spring2020-Team22",
    packages=find_packages(),
    install_requires=requirements_list,
    classifiers=[
        "Programming Language :: Python :: 3.7",
        "License :: OSI Approved :: GNU General Public License v3 (GPLv3)",
    ],
)