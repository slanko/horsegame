using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DescriptorDisplay : MonoBehaviour
{
    public Descriptor descriptor;
    
    public Text descriptionText;
    public Image picture;
  



    // Start is called before the first frame update
    void Start()
    {
       
        descriptionText.text = descriptor.Description;
        picture.sprite = descriptor.picture;
    }

   
}
