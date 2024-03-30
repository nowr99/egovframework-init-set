package servlet.service;

import org.springframework.web.multipart.MultipartFile;

public interface FileService {

	int uploadFile(MultipartFile multi);

	void deleteTable();

	void updateTable();



}
