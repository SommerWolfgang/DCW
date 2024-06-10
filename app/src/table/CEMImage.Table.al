table 6086400 "CEM Image"
{
    Caption = 'Image';
    LookupPageID = "CEM Image List";

    fields
    {
        field(1; Description; Text[50])
        {
            Caption = 'Description';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; Description)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure InsertDefaultImages()
    var
        Image: Record "CEM Image";
        i: Integer;
    begin
        if Image.IsEmpty then
            for i := 1 to 20 do begin
                if i < 10 then
                    Image.Description := '0' + Format(i)
                else
                    Image.Description := Format(i);
                Image.Insert;
            end;
    end;
}

