FROM ubuntu:22.04
COPY disk-check.sh /disk-check.sh
RUN chmod +x /disk-check.sh
CMD ["/disk-check.sh"]
