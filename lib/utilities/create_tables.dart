/// Created by Yunus Emre Yıldırım
/// on 23.09.2022

const tableSentenceName = 'sentence';
const tableDirectoryName = 'directory';

const createSentenceTable = '''
      CREATE TABLE $tableSentenceName (
      "id" TEXT PRIMARY KEY NOT NULL,
      "title" TEXT NOT NULL,
      "content" TEXT NOT NULL,
      "directoryId" TEXT,
      FOREIGN KEY("directoryId") REFERENCES $tableDirectoryName("id") ON DELETE CASCADE ON UPDATE CASCADE
      )''';

const createDirectoryTable = '''
      CREATE TABLE $tableDirectoryName (
      "id" TEXT PRIMARY KEY NOT NULL,
      "name" TEXT NOT NULL,
      "sentenceCount" INTEGER NOT NULL
      )''';
