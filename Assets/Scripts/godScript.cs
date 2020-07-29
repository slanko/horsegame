using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class godScript : MonoBehaviour
{
    public characterController cC;
    public characterInteract charInt;
    public Slider tamingSlider;
    public GameObject tamingSliderParent;
    public KeyCode tameKey;

    public List<GameObject> horseList;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(cC.currentState == characterController.playerState.TAMING)
        {
            if(cC.enteredTaming == false)
            {
                tamingSlider.value = charInt.hB.tamingGoal / 4;
                cC.enteredTaming = true;
            }
            tamingSliderParent.SetActive(true);
            tamingSlider.maxValue = charInt.hB.tamingGoal;
            if (Input.GetKeyDown(tameKey))
            {
                tamingSlider.value = tamingSlider.value + 10;
            }
            if(tamingSlider.value == tamingSlider.maxValue)
                {
                charInt.hB.isTamed = true;
                cC.goToRide();
            }
            tamingSlider.value = tamingSlider.value - charInt.hB.timerDecrease * Time.deltaTime;
        }
        else
        {
            tamingSliderParent.SetActive(false);
        }
    }
}
