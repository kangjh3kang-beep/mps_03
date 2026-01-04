"""
DiffMeas Python SDK Setup
"""

from setuptools import setup, find_packages

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setup(
    name="diffmeas-sdk",
    version="1.0.0",
    author="Manpasik Team",
    author_email="dev@manpasik.com",
    description="DiffMeas SDK for Python - 만파식적 측정 장비 연동 SDK",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/manpasik/diffmeas-sdk-python",
    project_urls={
        "Bug Tracker": "https://github.com/manpasik/diffmeas-sdk-python/issues",
        "Documentation": "https://docs.manpasik.com/sdk/python",
    },
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "Intended Audience :: Healthcare Industry",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Programming Language :: Python :: 3.12",
        "Topic :: Scientific/Engineering :: Medical Science Apps.",
        "Typing :: Typed",
    ],
    packages=find_packages(exclude=["tests", "tests.*"]),
    python_requires=">=3.9",
    install_requires=[
        "bleak>=0.21.0",
        "aiohttp>=3.9.0",
        "pydantic>=2.0.0",
        "numpy>=1.24.0",
    ],
    extras_require={
        "dev": [
            "pytest>=7.4.0",
            "pytest-asyncio>=0.21.0",
            "pytest-cov>=4.1.0",
            "black>=23.0.0",
            "mypy>=1.5.0",
            "ruff>=0.1.0",
        ],
        "docs": [
            "sphinx>=7.0.0",
            "sphinx-rtd-theme>=1.3.0",
        ],
    },
    entry_points={
        "console_scripts": [
            "diffmeas-cli=diffmeas.cli:main",
        ],
    },
)

