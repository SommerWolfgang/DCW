table 6086336 "CEM Lookup Value Access"
{
    Caption = 'Lookup Value Access';

    fields
    {
        field(1; "Field Type Code"; Code[20])
        {
            Caption = 'Field Type Code';
            NotBlank = true;
            TableRelation = "CEM Field Type";
        }
        field(2; "Parent Field Type Code"; Code[50])
        {
            Caption = 'Parent Field Type Code';
            TableRelation = "CEM Lookup Value"."Parent Field Type Code" where("Field Type Code" = field("Field Type Code"));
        }
        field(3; "Value Code"; Code[50])
        {
            Caption = 'Value Code';
            NotBlank = true;
            TableRelation = "CEM Lookup Value".Code where("Field Type Code" = field("Field Type Code"),
                                                           "Parent Field Type Code" = field("Parent Field Type Code"));
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'User,Group';
            OptionMembers = User,Group;

            trigger OnValidate()
            begin
                if Type <> xRec.Type then
                    Clear(Code);
            end;
        }
        field(6; "Code"; Code[50])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = if (Type = const(User)) "CDC Continia User Setup"
            else
            if (Type = const(Group)) "CEM Expense User Group";
        }
        field(10; "Value Description"; Text[50])
        {
            CalcFormula = lookup("CEM Lookup Value".Description where("Field Type Code" = field("Field Type Code"),
                                                                       Code = field("Value Code"),
                                                                       "Parent Field Type Code" = field("Parent Field Type Code")));
            Caption = 'Value Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Field Type Code", "Parent Field Type Code", "Value Code", Type, "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        Fieldtype: Record "CEM Field Type";
    begin
        Fieldtype.Get("Field Type Code");
        if Fieldtype.GetParentFieldTypeCode() <> '' then
            TestField("Parent Field Type Code");
    end;


    procedure IsValid(): Boolean
    var
        ContiniaUser: Record "CDC Continia User";
        ExpenseUserGroup: Record "CEM Expense User Group";
        FieldType: Record "CEM Field Type";
        LookupValue: Record "CEM Lookup Value";
    begin
        if "Value Code" = '' then
            exit(false);

        if Code = '' then
            exit(false);

        if not FieldType.Get("Field Type Code") then
            exit(false);

        if not (FieldType.Type in [FieldType.Type::Code, FieldType.Type::Option]) then
            exit(false);

        if "Parent Field Type Code" <> '' then
            if not FieldType.Get("Parent Field Type Code") then
                exit(false);

        if not LookupValue.Get("Field Type Code", "Parent Field Type Code", "Value Code") then
            exit(false);

        if Type = Type::User then
            if not ContiniaUser.Get(Code) then
                exit(false);

        if Type = Type::Group then
            if not ExpenseUserGroup.Get(Code) then
                exit(false);

        exit(true);
    end;
}

