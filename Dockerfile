# Use an Erlang/OTP base image compatible with ejabberd
FROM erlang:26

# Set environment variables
ENV LANG=C.UTF-8 \
    EJABBERD_HOME=/opt/ejabberd

# Install necessary build and PostgreSQL dependencies
RUN apt-get update && \
    apt-get install -y \
      build-essential \
      libyaml-dev \
      libexpat1-dev \
      libsqlite3-dev \
      git \
      autoconf \
      libssl-dev \
      libpam0g-dev \
      libpq-dev \
      pkg-config && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create application directory
RUN mkdir -p $EJABBERD_HOME
WORKDIR $EJABBERD_HOME

# Copy ejabberd source code
COPY . .

# Build ejabberd with PostgreSQL support
RUN ./autogen.sh && \
    ./configure --prefix=$EJABBERD_HOME/build --enable-pgsql && \
    make && \
    make install

# Copy custom pg.sql into correct priv/sql directory inside built path
RUN set -ex && \
    target_dir=$(find $EJABBERD_HOME/build/lib -maxdepth 1 -type d -name "ejabberd-*") && \
    mkdir -p "$target_dir/priv/sql" && \
    cp sql/pg.sql "$target_dir/priv/sql/pg.sql"

# Set PATH to include ejabberd binaries
ENV PATH="$EJABBERD_HOME/build/sbin:$PATH"

# Expose standard ejabberd ports
EXPOSE 5222 5269 5280 5443

# Default command: run ejabberd in foreground
CMD ["ejabberdctl", "foreground"]
