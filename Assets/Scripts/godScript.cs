using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class godScript : MonoBehaviour
{
    public GameObject godlet;
    public characterController cC;
    public characterInteract charInt;
    public Slider tamingSlider;
    public GameObject tamingSliderParent;
    public KeyCode tameKey;
    public bool tutorialTime;
    public tutorialBoolz tBz;
    public List<GameObject> horseList;
    public AudioSource muzik;
    public float audioVolume;
    public float horseCount;

    // Start is called before the first frame update
    void Awake()
    {
        Time.timeScale = 1f;
        muzik = GetComponent<AudioSource>();
        if(tutorialTime == true)
        {
            tBz = GameObject.Find("GOD/godlet").GetComponent<tutorialBoolz>();
        }
    }

    // Update is called once per frame
    void Update()
    {
        if(cC.currentState == characterController.playerState.TAMING)
        {
            if(cC.enteredTaming == false)
            {
                if(charInt.hB.imHappy == true)
                {
                    tamingSlider.value = charInt.hB.tamingGoal / 2;
                }
                else
                {
                    tamingSlider.value = charInt.hB.tamingGoal / 3;
                }
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
                if (tutorialTime == true)
                {
                    tBz.setFifthBool();
                }
            }
            tamingSlider.value = tamingSlider.value - charInt.hB.timerDecrease * Time.deltaTime;
        }
        else
        {
            tamingSliderParent.SetActive(false);
        }
    }
}
