table 6086230 "CTS-CDN XML Export Namespace"
{
    Caption = 'XML Namespace';

    fields
    {
        field(1; Name; Text[250])
        {
            Caption = 'Name';

            trigger OnValidate()
            begin
                if not XMLNS then
                    if StrPos(Name, 'xmlns:') = 0 then
                        Name := StrSubstNo('xmlns:%1', Name);
            end;
        }
        field(2; URL; Text[250])
        {
            Caption = 'URL';
        }
        field(3; XMLNS; Boolean)
        {
            Caption = 'XMLNS';

            trigger OnValidate()
            begin
                if Name = '' then
                    Name := 'xmlns';
            end;
        }
    }

    keys
    {
        key(Key1; Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure AddNamespace(NamespaceName: Text[1024]; NamespaceUri: Text[1024])
    begin
        Init();

        if NamespaceName = '' then
            Validate(XMLNS, true)
        else
            Validate(Name, NamespaceName);

        Validate(URL, NamespaceUri);
        Insert(true);
    end;
}

