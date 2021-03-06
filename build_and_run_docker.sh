#Preci na CudaDocker direktorijum
cd CUDA_Docker/
#Build docker file
#Ukoliko neko nije izbrisao image sa serve-ra, može da se preskoči ovaj deo
nvidia-docker build --tag=cudawatershed .

#Pokretanje kreiranog image-a
#--privileged flag ne bi trebalo da se koristi, ali nisam nasao drugi način ..
#.. da pokrenem Intel PCM (za merenje utrošene energie) jer zahteva permisije ..
#.. za upis u Docker file system što je po default-u zabranjeno
nvidia-docker run -it --privileged cudawatershed

#Uklonite watch_dog flag kako bi omogućili očitavanje statusa CPU-a
echo '0' > /proc/sys/kernel/nmi_watchdog

#Pokretanje moje verzije pograma - svi delovi se izvrsavaju sekvencijalno
./acc/acc_singlecore.exe ./TestData/dem1.tif dem1_acc_result.tif

#Pokretanje moje verzije pograma - svi delovi se izvrsavaju paralelno samo na CPU
./acc/acc_multicore.exe ./TestData/dem1.tif dem1_acc_result.tif

#Pokretanje moje verzije pograma - svi delovi se izvrsavaju paralelno na GPU0
./acc/acc_gpu_35.exe ./TestData/dem1.tif dem1_acc_result.tif

#Pokretanje vase verzije programa sekvencijalno
./cuda_10.exe ./TestData/dem1.tif dem1_cuda_result.tif cpu_st ftm 0.01

#Pokretanje vase verzije programa - paralelizacija pomocu OpenMP-a
./cuda_10.exe ./TestData/dem1.tif dem1_cuda_result.tif cpu_mt ftm 0.01

#Pokretanje vase verzije programa pomocu CUDA framework-a
./cuda_10.exe ./TestData/dem1.tif dem1_cuda_result.tif gpu ftm 0.01

#Izlazak iz Docker-a:
exit

#Zaustavnjanje i brisanje image-a (ovo moze da se preskoci)
nvidia-docker rmi -f cudawatershed


#Dobijanje inforamcija o cpu i gpu
cat /proc/cpuinfo 

nvidia-smi
