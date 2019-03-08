#include "synchroniser.h"
#include "./../db/dbactions.h"


Synchroniser::Synchroniser(QObject *parent) : QObject (parent)
{
    this->dba = DBActions::getInstance();
}


FMH::MODEL_LIST Synchroniser::getContacts(const QString &query)
{
    Q_UNUSED(query)

    return {
        {{FMH::MODEL_KEY::N, "Camilo Higuita"}, {FMH::MODEL_KEY::TITLE, "MauiKit Dev"}, {FMH::MODEL_KEY::TEL, "+57 3197673511"},  {FMH::MODEL_KEY::EMAIL, "camilohiguita@maui.org"}},
        {{FMH::MODEL_KEY::N, "Anupam Basak"}, {FMH::MODEL_KEY::TITLE, "Nitrux Dev"}, {FMH::MODEL_KEY::EMAIL, "anupam_dev@maui.org"} },
        {{FMH::MODEL_KEY::N, "Uri Herrera"}, {FMH::MODEL_KEY::TITLE, "Nitrux founder"}},
        {{FMH::MODEL_KEY::N, "Valentina R"}, {FMH::MODEL_KEY::TITLE, "Designer"},  {FMH::MODEL_KEY::EMAIL, "uri_herera@maui.org"}},
        {{FMH::MODEL_KEY::N, "Daniel Ray"}, {FMH::MODEL_KEY::TITLE, "Testing"}, {FMH::MODEL_KEY::TEL, "+57 3197673511"}},
        {{FMH::MODEL_KEY::N, "Esteban Ergh"}, {FMH::MODEL_KEY::TITLE, "Testing"}, {FMH::MODEL_KEY::TEL, "+57 3197673511"}},
        {{FMH::MODEL_KEY::N, "Sebastian Maui"}, {FMH::MODEL_KEY::TITLE, "Testing"}, {FMH::MODEL_KEY::TEL, "+57 3197673511"}, {FMH::MODEL_KEY::EMAIL, "testing@maui.org"}},
        {{FMH::MODEL_KEY::N, "Camila Test"}, {FMH::MODEL_KEY::TITLE, "Testing"}, {FMH::MODEL_KEY::TEL, "+57 3197673511"}},
        {{FMH::MODEL_KEY::N, "Aleix Unkown"}, {FMH::MODEL_KEY::TITLE, "Testing"}, {FMH::MODEL_KEY::TEL, "+57 3197673511"}, {FMH::MODEL_KEY::EMAIL, "testing@maui.org"}},
        {{FMH::MODEL_KEY::N, "Daniel Ray"}, {FMH::MODEL_KEY::TITLE, "Testing"}, {FMH::MODEL_KEY::TEL, "+57 3197673511"}},
        {{FMH::MODEL_KEY::N, "Pin Test"}, {FMH::MODEL_KEY::TITLE, "MauiKit Dev"}},
        {{FMH::MODEL_KEY::N, "Hello World Higuita"}, {FMH::MODEL_KEY::TITLE, "MauiKit Dev"},  {FMH::MODEL_KEY::EMAIL, "testing@maui.org"}},
        {{FMH::MODEL_KEY::N, "Alejandro Higuita"}, {FMH::MODEL_KEY::TITLE, "MauiKit Dev"}},
        {{FMH::MODEL_KEY::N, "Julian Higuita"}, {FMH::MODEL_KEY::TITLE, "MauiKit Dev"}, {FMH::MODEL_KEY::EMAIL, "testing@maui.org"}},
        {{FMH::MODEL_KEY::N, "Andres Higuita"}, {FMH::MODEL_KEY::TITLE, "MauiKit Dev"}}
    };
}

bool Synchroniser::insertContact(const FMH::MODEL &contact)
{
    return this->dba->insertContact(contact);
}
