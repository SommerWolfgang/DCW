table 6085599 "CDC Temp. Document Page"
{
    Caption = 'Temp. Document Page';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(3; "Page"; Integer)
        {
            BlankZero = true;
            Caption = 'Page';
        }
        field(4; "Source ID"; Text[250])
        {
            Caption = 'Source ID';
        }
        field(5; Name; Text[250])
        {
            Caption = 'Name';
        }
        field(6; "Document Category Code"; Code[10])
        {
            Caption = 'Document Category Code';
        }
        field(7; "Display Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(8; "Original Filename"; Text[250])
        {
            Caption = 'Original Filename';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Document No.", "Page")
        {
        }
    }

    fieldgroups
    {
    }


    procedure BuildTable(DocCatCode: Code[10]; var Document: Record "CDC Document")
    var
        DocumentPage: Record "CDC Document Page";
        i: Integer;
    begin
        Reset();
        DeleteAll();
        Document.SetCurrentKey("Document Category Code", Status);
        if DocCatCode <> '' then
            Document.SetRange("Document Category Code", DocCatCode);
        Document.SetRange(Status, Document.Status::Open);
        Document.SetFilter("File Type", StrSubstNo('%1|%2', Document."File Type"::XML, Document."File Type"::OCR));
        if Document.FindSet() then
            repeat
                "Display Document No." := Document."No.";
                "Source ID" := Document.GetSourceID();
                Name := Document.GetSourceName();

                Document.CalcFields("No. of Pages");
                for i := 1 to Document."No. of Pages" do begin
                    "Entry No." := "Entry No." + 10000;
                    "Document No." := Document."No.";
                    Page := i;
                    "Document Category Code" := Document."Document Category Code";
                    if DocumentPage.Get("Document No.", Page) then
                        "Original Filename" := CopyStr(DocumentPage."Original Filename", 1, MaxStrLen("Original Filename"));
                    Insert();
                    "Display Document No." := '';
                end;
            until Document.Next() = 0;

        if ("Entry No." <> 0) and (Page = 0) then
            Delete();

        if FindFirst() then;
    end;
}

