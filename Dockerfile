FROM reg.aichallenge.ir/aic/infra/final_judgment:486-b2af3cf0  
#FROM reg.aichallenge.ir/python:3.8

#RUN apt-get update && \
#apt install -y default-jre vim curl gettext


# log directory
#RUN mkdir -p /var/log/final-judgment


#################################### install final_judgment ########################### 

WORKDIR /home
ADD ./requirements.txt ./requirements.txt
ENV PIP_NO_CACHE_DIR 1
RUN pip install -r ./requirements.txt
ADD ./src ./src

#################################### install match holder #############################

# download server jar file
#RUN mkdir -p /usr/local/match && \
#curl -s https://api.github.com/repos/sharifaichallenge/aic21-server/releases/latest \
#| grep "browser_download_url.*jar" \
#| cut -d : -f 2,3 \
#| tr -d '"' \
#| wget -i - -O /usr/local/match/match.jar

curl https://github-releases.githubusercontent.com/360239647/60540280-a923-11eb-9a13-e8d48d42aea3?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20210502%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20210502T091536Z&X-Amz-Expires=300&X-Amz-Signature=db3b6933372dd222903295922070a01e5ba3ef592a3bc0efc89133108542e64a&X-Amz-SignedHeaders=host&actor_id=45825003&key_id=0&repo_id=360239647&response-content-disposition=attachment%3B%20filename%3Dmini-server-v3.0.1.jar&response-content-type=application%2Foctet-stream -o /usr/local/match/match.jar

# download server configfile
RUN curl "https://raw.githubusercontent.com/SharifAIChallenge/final-judgment/master/resources/map.config" > /usr/local/match/map.config

# install match 
COPY scripts/match.sh /usr/bin/match
RUN chmod +x /usr/bin/match


################################### install spawn #####################################
COPY scripts/spawn.sh /usr/bin/spawn
COPY scripts/spawn1.sh /usr/bin/spawn1
COPY scripts/spawn2.sh /usr/bin/spawn2

RUN chmod +x /usr/bin/spawn && mkdir -p /etc/spawn && \
chmod +x /usr/bin/spawn1 && \
chmod +x /usr/bin/spawn2 

WORKDIR /home/src
