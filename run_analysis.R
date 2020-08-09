# Entrar a la carpeta descargada
carpeta <- getwd()
setwd(paste(carpeta,"/", "UCI HAR Dataset",sep = ""))
archivos <- list.files()

# Descargando la información
actividades <- read.table(archivos[1], col.names = c("N", "Actividad"))
features <- read.table(archivos[2], col.names = c("N", "Funcion"))
subject_test <- read.table("test/subject_test.txt", col.names = c("Subject"))
x_test <- read.table("test/X_test.txt",  col.names = features$Funcion)
y_test <- read.table("test/Y_test.txt", col.names = "Codigo")
subject_train <- read.table("train/subject_train.txt", col.names = "Subject")
x_train <- read.table("train/X_train.txt", col.names = features$Funcion)
y_train <- read.table("train/Y_train.txt", col.names = "Codigo")

# Combinando las tablas
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
Data <- cbind(subject,y,x)

# Obteniendo la información requerida
req_data  <- select(Data, Subject, Codigo, contains("mean"), contains("std") )

# Nombrar a las actividades
req_data$Codigo <- actividades[req_data$Codigo,2]

# Asignar campos descriptivos
names(req_data)[2] <- "Activity"
names(req_data) <- gsub("Acc", "Accelerometer", names(req_data))
names(req_data) <- gsub("Gyro", "Gyroscope", names(req_data))
names(req_data) <- gsub("BodyBody", "Body", names(req_data))
names(req_data) <- gsub("^f", "Frecuency", names(req_data))
names(req_data) <- gsub("^t", "Time", names(req_data))
names(req_data) <- gsub("tBody", "TimeBody", names(req_data))
names(req_data) <- gsub("-mean()", "Mean", names(req_data), ignore.case = TRUE)
names(req_data) <- gsub("-std()", "STD", names(req_data), ignore.case = TRUE)
names(req_data) <- gsub("-freq()", "Frequency", names(req_data), ignore.case = TRUE)
names(req_data) <- gsub("angle", "Angle", names(req_data))
names(req_data) <- gsub("gravity", "Gravity", names(req_data))

# Agrupando la data
Data2 <- req_data %>% group_by(Subject, Activity) %>% summarise_all(funs(mean))
