FROM arm32v7/debian

RUN uname -a

RUN apt update
RUN apt install -y --no-install-recommends \
    qtdeclarative5-dev libqt5serialport5-dev libqt5serialbus5-dev libqt5charts5-dev \
    qtlocation5-dev qtpositioning5-dev libqt5sensors5-dev qtmultimedia5-dev qtvirtualkeyboard-plugin 
    
RUN apt install -y --no-install-recommends \
    qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qtquick-virtualkeyboard \
    qml-module-qtsensors qml-module-qt-labs-settings  qml-module-qtmultimedia \
    qml-module-qt-labs-folderlistmodel qml-module-qtquick-dialogs qml-module-qtquick-extras \
    qml-module-qtquick-xmllistmodel qml-module-qtpositioning qml-module-qtlocation

RUN apt install -y --no-install-recommends \
    build-essential

ADD . /src
RUN mkdir /src/build/
WORKDIR /src/build/
RUN qmake ..
RUN make -j2