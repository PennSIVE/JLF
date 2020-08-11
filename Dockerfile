FROM pennsive/neuror:4.0
COPY atlas /atlas
COPY jlf_reg_thalamus.R /
ENTRYPOINT [ "/jlf_reg_thalamus.R" ]
