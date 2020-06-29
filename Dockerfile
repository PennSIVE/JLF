FROM pennsive/neuror:4.0
COPY atlas /atlas
COPY jlf_reg_thalamus.R /
ENTRYPOINT [ "docker-entrypoint.sh", "/jlf_reg_thalamus.R" ]
