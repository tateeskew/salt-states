include:
  - sensu.repositories

# Install Sensu 

sensu:
  pkg.installed:
    - require:
      - file: sensu-repo
