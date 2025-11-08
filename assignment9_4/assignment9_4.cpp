// Ryan Buck
// Assignment 9.4
// Performs encryption and decryption on a file using inline assembly.

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <cstddef>

using namespace std;

enum Mode { Encrypt, Decrypt };

string getInputFilePath();
bool filePathIsValid(const string& path);
Mode getMode();
vector<char> encryptFile(const string& path);
vector<char> decryptFile(const string& path);
void outputEncryptedData(vector<char> encryptedData);

const string OUTPUT_FILE = "encrypted.txt";

// Get input file, encrypt/decrypt it, then output it
int main() {
	string filePath = getInputFilePath();
	Mode mode = getMode();
	
	// Encrypt/decrypt the file then output
	vector<char> data;
	switch (mode) {
		case Encrypt:
			cout << "Your encrypted file:\n";
			data = encryptFile(filePath);
			outputEncryptedData(data);
			cout << "Encrypted data stored in encrypted.txt\n";
			break;
		case Decrypt:
			cout << "Your decrypted file:\n";
			data = decryptFile(filePath);
			cout << string(data.begin(), data.end()) << endl;
			break;
	}

	cout << endl;
	return 0;
}

// Get the input file path from the user
string getInputFilePath() {
	string filePath;
	bool validPath = false;

	while (!validPath) {
		cout << "Enter a file path to encrypt/decrypt.\n";
		cout << "Your path: ";
		getline(cin, filePath);

		validPath = filePathIsValid(filePath);
		if (!validPath) {
			cout << "File couldn't be opened! Please try a different path.\n\n";
		}
	}

	cout << endl;
	return filePath;
}

// Check if a file path is valid (able to be opened)
bool filePathIsValid(const string& path) {
	ifstream file;
	file.open(path);
	bool isSuccess = file.is_open();
	file.close();
	return isSuccess;
}

// Get the mode (encrypt or decrypt) from the user
Mode getMode() {
	int choice = -1;
	bool validChoice = false;
	
	while (!validChoice) {
		cout << "Would you like to encrypt or decrypt this file?\n";
		cout << "(1) Encrypt\n";
		cout << "(2) Decrypt\n";
		cout << "Your choice: ";
		cin >> choice;

		if (1 <= choice && choice <= 2) {
			validChoice = true;
		} else {
			cout << "Invalid choice! Your answer must be 1 or 2. Please try again.\n\n";
		}
	}

	cout << endl;
	return Mode(choice - 1);
}

// Encrypt the contents of the given file
vector<char> encryptFile(const string& path) {
	ifstream file;
	file.open(path, ios::binary);

	// Gets each character until end of file
	vector<char> encryptedData;
	char current;
	char currentEncrypted;
	while (file.get(current)) {
		__asm {
			mov al, current
			ror al, 3
			xor al, 01011010b
			not al
			rol al, 5
			xor al, 00000011b
			neg al
			mov currentEncrypted, al
		}
		encryptedData.push_back(currentEncrypted);
	}

	file.close();
	return encryptedData;
}

// Decrypt the contents of the given file
vector<char> decryptFile(const string& path) {
	ifstream file;
	file.open(path, ios::binary);

	// Gets each character until end of file
	vector<char> decryptedData;
	char current;
	char currentDecrypted;
	while (file.get(current)) {
		__asm {
			mov al, current
			neg al
			xor al, 00000011b
			ror al, 5
			not al
			xor al, 01011010b
			rol al, 3
			mov currentDecrypted, al
		}
		decryptedData.push_back(currentDecrypted);
	}

	file.close();
	return decryptedData;
}

// Output the encrypted data to a file
void outputEncryptedData(vector<char> encryptedData) {
	ofstream file;
	file.open(OUTPUT_FILE, ios::binary);

	for (int i = 0; i < encryptedData.size(); i++) {
		file.put(encryptedData[i]);
	}

	file.close();
}
