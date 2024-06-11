table 6086110 "CDC Template Upg."
{
    Caption = 'Template Upg.';
    DataCaptionFields = "No.", Type;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2; "Category Code"; Code[10])
        {
            Caption = 'Category Code';
            TableRelation = "CDC Document Category";
        }
        field(5; "Source Record ID Tree ID"; Integer)
        {
            Caption = 'Source Record ID Tree ID';
        }
        field(6; Default; Boolean)
        {
            Caption = 'Default';
        }
        field(7; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Identification,Master';
            OptionMembers = " ",Identification,Master;
        }
        field(9; "Recognize Lines"; Option)
        {
            Caption = 'Recognize Lines';
            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
        field(10; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(19; "Search Text"; Code[200])
        {
            Caption = 'Search Text';
        }
        field(44; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            var
                DocCat: Record "CDC Document Category";
                Customer: Record Customer;
                Vendor: Record Vendor;
            begin
            end;
        }
        field(45; "Source Record Table ID"; Integer)
        {
            Caption = 'Source Record Table ID';
        }
        field(46; "Source Record No."; Code[50])
        {
            Caption = 'Source Record No.';
        }
        field(47; "Source Record Name"; Text[100])
        {
            Caption = 'Source Record Name';
        }
        field(1060; "New field config (manual)"; Boolean)
        {
            Caption = 'New field config (manual)';
        }
        field(1061; "New field config (auto)"; Boolean)
        {
            Caption = 'New field config (auto)';
        }
        field(1062; Ignore; Boolean)
        {
            Caption = 'Ignore';
        }
        field(1063; Upgraded; Boolean)
        {
            Caption = 'Upgraded';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Category Code", Type)
        {
        }
        key(Key3; "Search Text")
        {
        }
        key(Key4; "Category Code", "Source Record ID Tree ID")
        {
        }
        key(Key5; "Source Record Table ID", "Source Record No.", "Category Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        CDCTemplateFieldUpg: Record "CDC Template Field Upg.";
    begin
        CDCTemplateFieldUpg.SetRange(CDCTemplateFieldUpg."Template No.", "No.");
        CDCTemplateFieldUpg.DeleteAll();
    end;

    trigger OnInsert()
    var
        DCSetup: Record "CDC Document Capture Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
    end;

    var
        ChangeSourceIDErr: Label 'You cannot change %1 because this template has been used on one or more documents.';
        ChargesTxt: Label 'charges';
        DiscAndChargesTxt: Label 'discounts and charges';
        DiscountsTxt: Label 'discounts';
        DuplicIdentTempErr: Label 'You can only have one identification template for a document category.';
        ExportStylesheetMsg: Label 'Export Template Stylesheet file';
        HeaderText: Label 'Header Fields';
        ImportStylesheetMsg: Label 'Import Template Stylesheet file';
        LineText: Label 'Line Fields';
        LineTextHidden: Label 'Line Fields (Currently Hidden)';
        NoMasterOnMasterErr: Label 'You cannot set a Master Template to be its own XML Master Template. ';
        NoStylesheetMsg: Label 'There is no XML Stylesheet file imported for this Template.';
        OverwriteStylesheetQst: Label 'There is already an XML Stylesheet file imported for this Template. Do you want to replace it?';
        PurchAutoAppErr: Label '''%1'' must be %2 when ''%3'' is %4 in %5 %6';
        RefreshHtmlQst: Label 'All Open Documents using this Template must be refreshed to reflect the new XML Stylesheet. This process might take a while, depending on the number of Documents. Do you want continue?';
        ReviewDiscChrgQst: Label 'There are %1 in the XML document that are not mapped in the Template.\\Would you like to review and add them now? ';
        SelectMainFileMsg: Label 'You must select a Stylesheet file from the Zip file.';
        SourceIDNotExistErr: Label '%1 %2 does not exist.';
        SourceIDText: Label 'Source ID';
        SourceNameText: Label 'Source Name';
        StylesheetUpdatedMsg: Label 'Stylesheet updated.';
        Text001: Label 'This template cannot be deleted because it has been used on one or more registered or rejected documents.';
        Text002: Label 'This template is used on %1 open documents.\\If you delete this template it will be removed from these documents and you must manually select another template.\\Do you want to continue?';
        Text003: Label '&Create New';
        Text004: Label 'Do you want to update %1 on all fields?';
        Text005: Label 'WARNING\\Your are about to delete system template %1.\\Do you want to continue?';
        Text006: Label 'N/A';
        Text007: Label 'You must specify Source ID.';
        Text008: Label 'Source ID';
        Text010: Label 'Updating templates\#1####################\@2@@@@@@@@@@@@@@@@@@@@';
        Text011: Label '%1 of %2';
        Text012: Label 'Templates updated: %1';
        Text013: Label 'Do you want to set %1 to only check amounts including VAT and not amounts excluding VAT?';
        Text014: Label 'Do you want to remove the field ''%1'' from this template?';
        Text015: Label 'When a new template is created, %1 is automatically set to the same values as on the %2.';
        UpdateTemplateQst: Label 'Do you want to update %1 on all templates created from %2 = %3 for the document category %4?';
        UpdStylesheetMsg: Label 'Updating Stylesheets\#1####################\@2@@@@@@@@@@@@@@@@@@@@';
        UpdStylesheetMsg2: Label '%1 %2 of %3';


    procedure RefreshUpgTables()
    var
        CDCTemplate: Record "CDC Template";
    begin
        CDCTemplate.SetRange("Prices Including VAT", true);
        if CDCTemplate.FindSet() then
            repeat
                InsertUpdateTemplateHeader(CDCTemplate);
                InsertUpdateTemplateFields(CDCTemplate);
            until CDCTemplate.Next() = 0;
    end;


    procedure SuggestUpgradeData(TemplateFilter: Text[100])
    var
        CDCTemplateUpg: Record "CDC Template Upg.";
    begin
        CDCTemplateUpg.SetRange(Upgraded, false);
        if TemplateFilter <> '' then
            CDCTemplateUpg.SetFilter("No.", TemplateFilter);
        CDCTemplateUpg.SetRange(CDCTemplateUpg."New field config (manual)", false);
        if CDCTemplateUpg.FindSet() then
            repeat
                UpgradeCDCFieldConfiguration(CDCTemplateUpg);
            until CDCTemplateUpg.Next() = 0;
    end;


    procedure UpgradeCDCTemplateField()
    var
        CDCTemplateField: Record "CDC Template Field";
        CDCTemplateFieldUpg: Record "CDC Template Field Upg.";
    begin
        SetRange(Ignore, false);
        SetRange(Upgraded, false);
        if FindSet() then
            repeat
                if "New field config (manual)" or "New field config (auto)" then begin
                    CDCTemplateFieldUpg.SetRange("Template No.", "No.");
                    if CDCTemplateFieldUpg.FindSet() then
                        repeat
                            CDCTemplateField.Get(CDCTemplateFieldUpg."Template No.", CDCTemplateFieldUpg.Type, CDCTemplateFieldUpg.Code);
                            CDCTemplateField."G/L Account Field Code" := CDCTemplateFieldUpg."New G/L Account Field Code";
                            CDCTemplateField."Transfer Amount to Document" := CDCTemplateFieldUpg."New Transfer Amt. to Document";
                            CDCTemplateField."Subtract from Amount Field" := CDCTemplateFieldUpg."New Subtract from Amount Field";
                            CDCTemplateField.Modify();
                        until CDCTemplateFieldUpg.Next() = 0;
                    Upgraded := true;
                    Modify();
                end;
            until Next() = 0;
    end;

    local procedure InsertUpdateTemplateHeader(TemplateRec: Record "CDC Template")
    begin
        Init();
        "No." := TemplateRec."No.";
        "Source Record ID Tree ID" := TemplateRec."Source Record ID Tree ID";
        "Recognize Lines" := TemplateRec."Recognize Lines";
        Description := TemplateRec.Description;
        "Prices Including VAT" := TemplateRec."Prices Including VAT";
        "Source Record Table ID" := TemplateRec."Source Record Table ID";
        "Source Record No." := TemplateRec."Source Record No.";
        "Source Record Name" := TemplateRec."Source Record Name";
        "Category Code" := TemplateRec."Category Code";
        Type := TemplateRec.Type;

        // Only templates, not already in the upgrade table, are added.
        if Insert() then;
    end;

    local procedure InsertUpdateTemplateFields(TemplateRec: Record "CDC Template")
    var
        CDCTemplateField: Record "CDC Template Field";
        CDCTemplateFieldUpg: Record "CDC Template Field Upg.";
    begin
        CDCTemplateField.SetRange(CDCTemplateField."Template No.", TemplateRec."No.");
        CDCTemplateField.SetFilter(CDCTemplateField.Code, '<>%1', 'VATAMOUNT');
        CDCTemplateField.SetRange("Data Type", CDCTemplateField."Data Type"::Number);
        if TemplateRec."Recognize Lines" = TemplateRec."Recognize Lines"::Yes then
            CDCTemplateField.SetRange(Type)
        else
            CDCTemplateField.SetRange(Type, CDCTemplateField.Type::Header);

        if CDCTemplateField.FindSet() then
            repeat
                CDCTemplateFieldUpg."Template No." := CDCTemplateField."Template No.";
                CDCTemplateFieldUpg.Type := CDCTemplateField.Type;
                CDCTemplateFieldUpg.Code := CDCTemplateField.Code;
                CDCTemplateFieldUpg."Data Type" := CDCTemplateField."Data Type";
                CDCTemplateFieldUpg."G/L Account Field Code" := CDCTemplateField."G/L Account Field Code";
                CDCTemplateFieldUpg."Transfer Amount to Document" := CDCTemplateField."Transfer Amount to Document";
                CDCTemplateFieldUpg."Subtract from Amount Field" := CDCTemplateField."Subtract from Amount Field";
                CDCTemplateFieldUpg."Field Name" := CDCTemplateField."Field Name";
                // Only template fields, not already in the upgrade table, are added.
                if CDCTemplateFieldUpg.Insert() then;
            until CDCTemplateField.Next() = 0;
    end;

    local procedure UpgradeCDCFieldConfiguration(var TemplateToUpgrade: Record "CDC Template Upg.") TemplateUpdated: Boolean
    var
        CDCTemplateFieldUpg: Record "CDC Template Field Upg.";
        CDCTemplateFieldUpg2: Record "CDC Template Field Upg.";
        CDCTemplateUpg: Record "CDC Template Upg.";
    begin
        CDCTemplateFieldUpg.SetRange(CDCTemplateFieldUpg."Template No.", TemplateToUpgrade."No.");
        CDCTemplateFieldUpg.SetRange(CDCTemplateFieldUpg.Type, CDCTemplateFieldUpg.Type::Header);

        case GetConfigurationType(CDCTemplateFieldUpg) of
            'EXVAT':
                begin
                    if CDCTemplateFieldUpg.FindSet() then
                        repeat
                            case CDCTemplateFieldUpg.Code of
                                'AMOUNTEXCLVAT':
                                    ;
                                'AMOUNTINCLVAT':
                                    begin
                                        CDCTemplateFieldUpg2.Get(CDCTemplateFieldUpg."Template No.", CDCTemplateFieldUpg.Type, 'AMOUNTEXCLVAT');
                                        CDCTemplateFieldUpg."New G/L Account Field Code" := CDCTemplateFieldUpg2."G/L Account Field Code";
                                        CDCTemplateFieldUpg."New Subtract from Amount Field" := CDCTemplateFieldUpg2."Subtract from Amount Field";
                                        CDCTemplateFieldUpg."New Transfer Amt. to Document" := CDCTemplateFieldUpg2."Transfer Amount to Document";
                                        CDCTemplateFieldUpg.Modify();
                                    end;
                            end;
                        until CDCTemplateFieldUpg.Next() = 0;
                    if SetUpgradeStatus(CDCTemplateFieldUpg, 'EXVAT') then begin
                        TemplateToUpgrade."New field config (auto)" := true;
                        TemplateToUpgrade.Modify();
                    end;
                end;
            'EXVATFREIGHT':
                begin
                    if CDCTemplateFieldUpg.FindSet() then
                        repeat
                            case CDCTemplateFieldUpg.Code of
                                'AMOUNTEXCLVAT':
                                    ;
                                'FREIGHTAMOUNT':
                                    begin
                                        CDCTemplateFieldUpg2.Get(CDCTemplateFieldUpg."Template No.", CDCTemplateFieldUpg.Type, 'FREIGHTAMOUNT');
                                        CDCTemplateFieldUpg."New Subtract from Amount Field" := 'AMOUNTINCLVAT';
                                        CDCTemplateFieldUpg."New Transfer Amt. to Document" := CDCTemplateFieldUpg2."Transfer Amount to Document";
                                        CDCTemplateFieldUpg.Modify();
                                    end;
                                'AMOUNTINCLVAT':
                                    begin
                                        CDCTemplateFieldUpg2.Get(CDCTemplateFieldUpg."Template No.", CDCTemplateFieldUpg.Type, 'AMOUNTEXCLVAT');
                                        CDCTemplateFieldUpg."New G/L Account Field Code" := CDCTemplateFieldUpg2."G/L Account Field Code";
                                        CDCTemplateFieldUpg."New Subtract from Amount Field" := CDCTemplateFieldUpg2."Subtract from Amount Field";
                                        CDCTemplateFieldUpg."New Transfer Amt. to Document" := CDCTemplateFieldUpg2."Transfer Amount to Document";
                                        CDCTemplateFieldUpg.Modify();
                                    end;
                            end;
                        until CDCTemplateFieldUpg.Next() = 0;
                    if SetUpgradeStatus(CDCTemplateFieldUpg, 'EXVATFREIGHT') then begin
                        TemplateToUpgrade."New field config (auto)" := true;
                        TemplateToUpgrade.Modify();
                    end;
                end;
        end;
    end;

    local procedure GetConfigurationType(var CDCTemplateFieldUpg: Record "CDC Template Field Upg.") ConfigType: Code[20]
    begin
        if CDCTemplateFieldUpg.Count = 2 then begin
            // Ensure the amount field configuration is as expected - only AMOUNTEXCLVAT and AMOUNTINCLVAT are setup on the template
            CDCTemplateFieldUpg.SetFilter(Code, '<>%1&<>%2', 'AMOUNTEXCLVAT', 'AMOUNTINCLVAT');
            if CDCTemplateFieldUpg.Count <> 0 then
                exit('');
            CDCTemplateFieldUpg.SetRange(Code);
            exit('EXVAT');
        end;
        if CDCTemplateFieldUpg.Count = 3 then begin
            // Ensure amount field configuration is as expected - only AMOUNTEXCLVAT, AMOUNTINCLVAT and FREIGHTAMOUNT are setup on the template
            CDCTemplateFieldUpg.SetFilter(Code, '<>%1&<>%2&<>%3', 'AMOUNTEXCLVAT', 'AMOUNTINCLVAT', 'FREIGHTAMOUNT');
            if CDCTemplateFieldUpg.Count <> 0 then
                exit('');
            CDCTemplateFieldUpg.SetRange(Code);
            exit('EXVATFREIGHT');
        end;
    end;

    local procedure SetUpgradeStatus(var CDCTemplateFieldUpg: Record "CDC Template Field Upg."; ConfigType: Code[20]) DoModify: Boolean
    begin
        CDCTemplateFieldUpg.FindFirst();
        case ConfigType of
            'EXVATFREIGHT':
                begin
                    repeat
                        if CDCTemplateFieldUpg.Code = 'AMOUNTINCLVAT' then
                            DoModify := (CDCTemplateFieldUpg."New G/L Account Field Code" <> '') and
                              (CDCTemplateFieldUpg."New Transfer Amt. to Document" =
                               CDCTemplateFieldUpg."New Transfer Amt. to Document"::"If lines are not recognised");

                        if CDCTemplateFieldUpg.Code = 'FREIGHTAMOUNT' then
                            DoModify := DoModify and (CDCTemplateFieldUpg."New Subtract from Amount Field" <> '') and
                              (CDCTemplateFieldUpg."New Transfer Amt. to Document" = CDCTemplateFieldUpg."New Transfer Amt. to Document"::Always);
                    until CDCTemplateFieldUpg.Next() = 0;
                end;
            'EXVAT':
                begin
                    repeat
                        if CDCTemplateFieldUpg.Code = 'AMOUNTINCLVAT' then
                            DoModify := (CDCTemplateFieldUpg."New G/L Account Field Code" <> '') and
                              (CDCTemplateFieldUpg."New Transfer Amt. to Document" =
                               CDCTemplateFieldUpg."New Transfer Amt. to Document"::"If lines are not recognised");
                    until CDCTemplateFieldUpg.Next() = 0;
                end;
        end;
    end;
}

